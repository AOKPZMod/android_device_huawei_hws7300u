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

import com.cyanogenmod.settings.device.Helpers;
import com.cyanogenmod.settings.device.CMDProcessor;
import com.cyanogenmod.settings.device.CMDProcessor.CommandResult;

/**
 * Created with IntelliJ IDEA.
 * User: zyr3x
 * Date: 19.11.12
 * Time: 10:19
 * To change this template use File | Settings | File Templates.
 */
public class BootService extends Service {

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

        private String getProp(String key, String def) {
            CMDProcessor cmd = new CMDProcessor();
            CommandResult result = cmd.suOrSH().runWaitFor("getprop " + key);
            return (result.getOutput().getFirst().equals("") || result.getOutput().getFirst() == null) ? def : result.getOutput().getFirst();
        }

        private void updateBatteryProp() {
            CMDProcessor cmd = new CMDProcessor();
            String cap = getProp(DeviceSettings.PROP_BATTERY_MIN_CAPACITY, "-1");
            String vol = getProp(DeviceSettings.PROP_BATTERY_MIN_VOLT, "3500");

            Helpers.getMount("rw");
            cmd.suOrSH().run("echo " + cap + " > /system/etc/coulometer/bq27510_min_capacity");
            cmd.suOrSH().run("echo " + vol + " > /system/etc/coulometer/bq27510_min_volt");
            Helpers.getMount("ro");
        }

        private void updateTouchwake() {
            CMDProcessor cmd = new CMDProcessor();
            String value = getProp(DeviceSettings.PROP_TOUCHWAKE, "0");
            cmd.suOrSH().run("echo " + value + " > /sys/class/misc/touchwake/enabled");
            cmd.suOrSH().run("echo 90000 > /sys/class/misc/touchwake/delay");
        }

        private void updateDisplayVoltage() {
            CMDProcessor cmd = new CMDProcessor();
            String value = getProp(DeviceSettings.PROP_DISPLAY_VOLTAGE, "3300000");
            cmd.suOrSH().run("echo " + value + " > /sys/bus/platform/drivers/lcdc_s7Pro_lvds_wxga/voltage");
        }

        @Override
        protected Void doInBackground(Void... args) {
            updateBatteryProp();
            updateTouchwake();
            updateDisplayVoltage();
            if (getProp(DeviceSettings.PROP_HW_OVERLAY, "1").equals("0")) {
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
