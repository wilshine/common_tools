package com.xiaopeng.tool.xp_tool;

import android.app.DownloadManager;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.database.ContentObserver;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;


/**
 *
 */
public class SystemDownloadHelper {

    private static final String MineType_APK = "application/vnd.android.package-archive";
    public static final Uri CONTENT_URI = Uri.parse("content://downloads");
    public static boolean isSilent = false;

    private static DownloadManager.Request getDownloadRequest(Context context, Uri uri, final String directory, String fileName, boolean isSilent) {
        DownloadManager.Request request = new DownloadManager.Request(uri);
        request.setAllowedOverRoaming(false);// 禁止漫游下载
        request.setVisibleInDownloadsUi(true);
        if (isSilent) {
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_HIDDEN);
        } else {
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        }
        //指定下载路径及文件名
//        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, fileName); //sdcard/Download/xxx.apk
        request.setDestinationInExternalFilesDir(context, Environment.DIRECTORY_DOWNLOADS, fileName);//sdcard/
        request.setMimeType(MineType_APK);
        return request;
    }


    /**
     * 下载文件
     *
     * @param mContext
     * @param url
     * @param directory
     * @param fileName
     * @param isSilent
     * @param listener
     * @return
     */
    public static long startDownload(final Context mContext, final String url, final String directory, final String fileName, boolean isSilent, OnSysDownloadStateChangeListener listener) {
        long downloadId = 0;
        try {
            if (TextUtils.isEmpty(url)) {
                return -1;
            }

            DownloadManager downloadManager = (DownloadManager) mContext.getSystemService(Context.DOWNLOAD_SERVICE);
            Uri uri = Uri.parse(url);
            downloadId = downloadManager.enqueue(getDownloadRequest(mContext, uri, directory, fileName, isSilent));
            SystemDownloadHelper.isSilent = isSilent;
            addDownloadWatcher(mContext, downloadId, listener);
            return downloadId;
        } catch (Exception e) {//下载失败的话,用浏览器下载
            downLoadByBrowser(mContext, url);
            e.printStackTrace();
            if (listener != null) {
                listener.onFail(downloadId);
            }
            return -1;
        }
    }

    private static void addDownloadWatcher(final Context mContext, final long downloadId, final OnSysDownloadStateChangeListener listener) {
        try {
            mContext.getContentResolver().registerContentObserver(CONTENT_URI, true, new ContentObserver(null) {
                boolean isStart = false;
                boolean isPause = false;

                @Override
                public void onChange(boolean selfChange) {

                    int status = getDownloadStatus(mContext, downloadId);
                    Log.i("SystemDownloadHelper", "  status=" + status);
                    switch (status) {
                        case DownloadManager.STATUS_SUCCESSFUL:// 8
                            if (listener != null) {
                                listener.onSuccess(downloadId);
                            }
                            mContext.getContentResolver().unregisterContentObserver(this);
                            break;
                        case DownloadManager.STATUS_PENDING:// 1
                            if (listener != null) {
                                listener.onPending(downloadId);
                            }
                            break;
                        case DownloadManager.STATUS_RUNNING:// 2
                            if (!isStart) {
                                isStart = true;
                                if (listener != null) {
                                    listener.onStart();
                                }
                            } else {
                                if (listener != null) {
                                    int progress = getDownloadProgress(mContext, downloadId);
                                    int total = getDownloadTotal(mContext, downloadId);
                                    listener.onRunning(downloadId, (double)progress/total);
                                }
                            }

                            break;
                        case DownloadManager.STATUS_PAUSED:// 4
                            if (!isPause) {
                                isPause = true;
                                if (listener != null) {
                                    listener.onPause();
                                }
                            }
                            break;
                        case -1://用户主动取消任务
                            if (listener != null) {
                                listener.onCancel(downloadId);
                            }
                            break;
                        case DownloadManager.STATUS_FAILED:// 16
                            if (listener != null) {
                                listener.onFail(downloadId);
                            }
                            mContext.getContentResolver().unregisterContentObserver(this);
                            break;

                        default:
                            break;
                    }
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void downLoadByBrowser(Context mContext, String url) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(Uri.parse(url));
            mContext.startActivity(intent);
        } catch (ActivityNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static int getDownloadStatus(Context mContext, long downloadId) {
        Cursor cursor = null;
        try {
            DownloadManager downloadManager = (DownloadManager) mContext.getSystemService(Context.DOWNLOAD_SERVICE);
            DownloadManager.Query query = new DownloadManager.Query();
            query.setFilterById(downloadId);
            cursor = downloadManager.query(query);
            cursor.moveToFirst();
            if (cursor.getCount() <= 0) return -1;
            return cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS));
        } catch (Exception e) {
            return -1;
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
    }

    public interface OnSysDownloadStateChangeListener {

        void onSuccess(long downloadId);

        void onFail(long downloadId);

        void onCancel(long downloadId);

        void onPending(long downloadId);

        void onRunning(long downloadId, double percent);

        void onPause();

        void onStart();
    }

    /**
     * 获取当前下载进度
     *
     * @return
     */
    static private int getDownloadProgress(final Context mContext, final long downloadId) {
        DownloadManager downloadManager = (DownloadManager) mContext.getSystemService(Context.DOWNLOAD_SERVICE);
        DownloadManager.Query query = new DownloadManager.Query().setFilterById(downloadId);
        Cursor c = downloadManager.query(query);
        if (c != null) {
            try {
                if (c.moveToFirst()) {
                    return c.getInt(c.getColumnIndex(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR));
                }
            } finally {
                c.close();
            }
        }
        return -1;

    }

    /**
     * 获取下载总大小
     *
     * @return
     */
    static private int getDownloadTotal(final Context mContext, final long downloadId) {
        DownloadManager downloadManager = (DownloadManager) mContext.getSystemService(Context.DOWNLOAD_SERVICE);
        DownloadManager.Query query = new DownloadManager.Query().setFilterById(downloadId);
        Cursor c = downloadManager.query(query);
        if (c != null) {
            try {
                if (c.moveToFirst()) {
                    return c.getInt(c.getColumnIndex(DownloadManager.COLUMN_TOTAL_SIZE_BYTES));
                }
            } finally {
                c.close();
            }
        }
        return -1;
    }
}
