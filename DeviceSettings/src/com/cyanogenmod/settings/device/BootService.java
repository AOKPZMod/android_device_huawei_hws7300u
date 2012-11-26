package com.cyanogenmod.settings.device;

import android.os.AsyncTask;
import android.os.IBinder;
import android.os.SystemProperties;
import android.util.Log;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.ServiceManager;
import android.os.Parcel;
import android.os.RemoteException;
import com.cyanogenmod.settings.device.tools.CMDProcessor;

/**
 * Created with IntelliJ IDEA.
 * User: zyr3x
 * Date: 19.11.12
 * Time: 10:19
 * To change this template use File | Settings | File Templates.
 */
public class BootService extends Service  {

        public static boolean servicesStarted = false;

        @Override
        public int onStartCommand(Intent intent, int flags, int startId) {
            if (intent == null) {
                stopSelf();
            }
            new BootWorker(this).execute();
            return START_STICKY;
        }

        @Override
        public IBinder onBind(Intent intent) {
            return null;
        }

        class BootWorker extends AsyncTask<Void, Void, Void> {

            Context c;

            public BootWorker(Context c) {
                this.c = c;
            }

            @Override
            protected Void doInBackground(Void... args) {
                if( SystemProperties.get(DeviceSettings.PROP_EXT_INTERNAL,"0").equals("1"))
                {
                    CMDProcessor cmd = new CMDProcessor();
                    cmd.rootCommand("mount -t vfat -o umask=0000 /dev/block/vold/179:97 /storage/sdcard0");
                    cmd.rootCommand("mount -o bind /data/media /storage/sdcard1");
                }
		if( SystemProperties.get(DeviceSettings.PROP_HW_OVERLAY,"1").equals("0") )
		{
			try {
            			IBinder flinger = ServiceManager.getService("SurfaceFlinger");
            			if (flinger != null) {
                			Parcel data = Parcel.obtain();
                			data.writeInterfaceToken("android.ui.ISurfaceComposer");
                			final int disableOverlays = 1; 
                			data.writeInt(disableOverlays);
                			flinger.transact(1008, data, null, 0);
                			data.recycle();
            			}
        		} catch (RemoteException ex) {	
        		}
		}
                return null;
            }

            @Override
            protected void onPostExecute(Void result) {
                super.onPostExecute(result);
                servicesStarted = true;
                stopSelf();
            }
        }

        @Override
        public void onDestroy() {
            super.onDestroy();
        }
}
