package com.cyanogenmod.settings.device;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.preference.*;
import android.os.Bundle;
import android.text.InputFilter;
import android.text.InputType;
import android.text.Spanned;
import android.util.Log;

import com.cyanogenmod.settings.device.CMDProcessor.CommandResult;

import android.os.SystemProperties;
import android.os.IBinder;
import android.os.ServiceManager;
import android.os.Parcel;
import android.os.RemoteException;
import android.widget.*;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DeviceSettings extends PreferenceActivity implements OnSharedPreferenceChangeListener {

    /**
     * Called when the activity is first created.
     */
    public static final String TAG = "MediapadSettings";

    public static final String KEY_LDC_COLOR = "lcd_color";
    public static final String KEY_DPI = "pref_dpi_list";
    public static final String KEY_WLAN_MAC = "wlan_mac";
    public static final String KEY_EXT_INT = "ext_internal";

    public static final String KEY_CAPACITY = "pref_battery_capacity";
    public static final String KEY_VOLT = "pref_battery_volt";

    public static final String KEY_TOUCHWAKE = "pref_touchwake";
    public static final String KEY_DISPLAY_VOLTAGE = "pref_display_voltage";

    public static final String PROP_DISPLAY_VOLTAGE = "persist.sys.display.voltage";
    public static final String PROP_COLOR_ENHANCE = "persist.sys.color.enhance";
    public static final String PROP_WLAN_MAC = "persist.wlan.mac";
    public static final String PROP_EXT_INTERNAL = "persist.extinternal";
    public static final String PROP_HW_OVERLAY = "persist.hw.overlay";
    public static final String PROP_BATTERY_MIN_CAPACITY = "persist.battery.min_capacity";
    public static final String PROP_BATTERY_MIN_VOLT = "persist.battery.min_volt";
    public static final String PROP_TOUCHWAKE = "persist.touchwake";

    private CheckBoxPreference mPrefColor;
    private Preference mPrefMac;
    private CheckBoxPreference mExtInternal;
    private CheckBoxPreference mTouchwake;

    protected CMDProcessor cmd =  new CMDProcessor();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.device_settings);
        getPreferenceScreen().getSharedPreferences().registerOnSharedPreferenceChangeListener(this);
        cmd = new CMDProcessor();
        initPreferenceActivity();


    }

    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {

        if (preference == mPrefColor)
            setProp(PROP_COLOR_ENHANCE, (mPrefColor.isChecked() ? "true" : "false"));

        if (preference == mTouchwake) {
            setProp(PROP_TOUCHWAKE, (mTouchwake.isChecked() ? "1" : "0"));
            cmd.suOrSH().run("echo " + (mTouchwake.isChecked() ? "1" : "0") + " > /sys/class/misc/touchwake/enabled");
            cmd.suOrSH().run("echo 90000 > /sys/class/misc/touchwake/delay");
        }


        if (preference == mPrefMac)
            setCustomMacDialog();

        if (preference == mExtInternal) {
            setProp(PROP_EXT_INTERNAL, (mExtInternal.isChecked() ? "1" : "0"));
            cmd.suOrSH().run("echo " + (mExtInternal.isChecked() ? "1" : "0") + " > /data/system/extinternal");
        }


        return false;
    }


    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {

        if (key.equals(KEY_DPI)) {
            int dpi = Integer.valueOf(sharedPreferences.getString(KEY_DPI, "213"));
            setLcdDensity(dpi);
        }

        if (key.equals(KEY_DISPLAY_VOLTAGE)) {
            int vol = Integer.valueOf(sharedPreferences.getString(KEY_DISPLAY_VOLTAGE, "3300000"));
            setProp(PROP_DISPLAY_VOLTAGE, vol + "");
            cmd.suOrSH().run("echo " + vol + " > /sys/bus/platform/drivers/lcdc_s7Pro_lvds_wxga/voltage");
        }

        if (key.equals(KEY_CAPACITY)) {
            int cap = Integer.valueOf(sharedPreferences.getString(KEY_CAPACITY, "0"));
            setProp(PROP_BATTERY_MIN_CAPACITY, cap + "");
            Helpers.getMount("rw");
            cmd.suOrSH().run("echo " + cap + " > /system/etc/coulometer/bq27510_min_capacity");
            Helpers.getMount("ro");
        }

        if (key.equals(KEY_VOLT)) {
            int vol = Integer.valueOf(sharedPreferences.getString(KEY_VOLT, "3500"));
            setProp(PROP_BATTERY_MIN_VOLT, vol + "");
            Helpers.getMount("rw");
            cmd.suOrSH().run("echo " + vol + " > /system/etc/coulometer/bq27510_min_volt");
            Helpers.getMount("ro");
        }

    }


    private void initPreferenceActivity() {
        mPrefMac = (Preference) findPreference(KEY_WLAN_MAC);


        mExtInternal = (CheckBoxPreference) findPreference(KEY_EXT_INT);
        mExtInternal.setChecked(getProp(PROP_EXT_INTERNAL, "0").equals("1"));

        mPrefColor = (CheckBoxPreference) findPreference(KEY_LDC_COLOR);
        mPrefColor.setChecked(getProp(PROP_COLOR_ENHANCE, "false").equals("true"));

        mExtInternal = (CheckBoxPreference) findPreference(KEY_EXT_INT);
        mExtInternal.setChecked(getProp(PROP_EXT_INTERNAL, "0").equals("1"));

        mTouchwake = (CheckBoxPreference) findPreference(KEY_TOUCHWAKE);
        mTouchwake.setChecked(getProp(KEY_TOUCHWAKE, "0").equals("1"));
    }

    private void setProp(String key, String val) {
        cmd.suOrSH().runWaitFor("setprop " + key + " \"" + val + "\"");
    }

    private String getProp(String key, String def) {
        CommandResult result = cmd.suOrSH().runWaitFor("getprop " + key);
        return (result.getOutput().getFirst().equals("") || result.getOutput().getFirst() == null) ? def : result.getOutput().getFirst();
    }

    private void setLcdDensity(int newDensity) {
        Helpers.getMount("rw");
        cmd.suOrSH().runWaitFor("busybox sed -i 's|ro.sf.lcd_density=.*|"
                + "ro.sf.lcd_density" + "=" + newDensity + "|' " + "/system/build.prop");
        Helpers.getMount("ro");
    }

    private void setCustomMacDialog() {
        final AlertDialog.Builder alert = new AlertDialog.Builder(this);
        final EditText input = new EditText(this);

        alert.setTitle(R.string.title_wlan_mac);
        alert.setView(input);

        input.setText(getProp(PROP_WLAN_MAC, ""));
        input.setInputType(InputType.TYPE_CLASS_TEXT);

        alert.setPositiveButton(getString(R.string.save), new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int whichButton) {
                setProp(PROP_WLAN_MAC, input.getText().toString().trim());
                dialog.cancel();
            }
        });

        alert.setNegativeButton(getString(R.string.cancel),
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                        dialog.cancel();
                    }
                });
        alert.show();
    }

}
