package com.damytech.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;
import android.util.Base64;
import android.view.View;
import android.widget.Toast;

import java.io.ByteArrayOutputStream;
import java.util.regex.Pattern;

public class GlobalData
{
    private static final Pattern EMAIL_ADDRESS_PATTERN = Pattern.compile(
	          "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
	          "\\@" +
	          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
	          "(" +
	          "\\." +
	          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
	          ")+"
	      );

    private static final Pattern PHONE_NUMBER_PATTERN = Pattern.compile("^[+]?[0-9]{10,13}$");
	
	private static Toast g_Toast = null;
	public static void showToast(Context context, String toastStr)
	{
		if ((g_Toast == null) || (g_Toast.getView().getWindowVisibility() != View.VISIBLE))
		{
			g_Toast = Toast.makeText(context, toastStr, Toast.LENGTH_SHORT);
			g_Toast.show();
		}

		return;
	}

	public static boolean isValidEmail(String strEmail)
	{
		return EMAIL_ADDRESS_PATTERN.matcher(strEmail).matches();
	}

    public static boolean isValidPhone(String strPhone)
    {
        return PHONE_NUMBER_PATTERN.matcher(strPhone).matches();
    }

    public static boolean isOnline(Context ctx)
    {
        ConnectivityManager cm = (ConnectivityManager) ctx.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        if (netInfo != null && netInfo.isConnectedOrConnecting()) {
            return true;
        }
        return false;
    }

    public static String getIMEI(Context context)
    {
        TelephonyManager tm = (TelephonyManager)context.getSystemService(context.TELEPHONY_SERVICE);
        return tm.getDeviceId();
    }

    public static String toDoubleNum(int c) {
        if (c >= 10)
            return String.valueOf(c);
        else
            return "0" + String.valueOf(c);
    }

    public static String g_strPrefName = "DingShengHui";
    public static String g_strPassFlag = "PassFlag";
    public static String g_strUserID = "UserID";
    public static String g_strUserName = "UserName";
    public static String g_strPass = "Password";

    public static boolean GetPassFlag(Context context)
    {
        boolean bRet = true;

        SharedPreferences pref = context.getSharedPreferences(g_strPrefName, Context.MODE_PRIVATE);
        bRet = pref.getBoolean(g_strPassFlag, false);

        return bRet;
    }

    public static void SetPassFlag(Context context, boolean bFlag)
    {
        SharedPreferences pref = context.getSharedPreferences(g_strPrefName, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putBoolean(g_strPassFlag, bFlag);
        editor.commit();

        return;
    }

    public static long GetUserID(Context context)
    {
        long nID = 0;

        SharedPreferences pref = context.getSharedPreferences(g_strPrefName, Context.MODE_PRIVATE);
        nID = pref.getLong(g_strUserID, 0);

        return nID;
    }

    public static void SetUserID(Context context, long nID)
    {
        SharedPreferences pref = context.getSharedPreferences(g_strPrefName, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putLong(g_strUserID, nID);
        editor.commit();

        return;
    }

    public static String GetUserName(Context context)
    {
        String strUserName = "";

        SharedPreferences pref = context.getSharedPreferences(g_strPrefName, Context.MODE_PRIVATE);
        strUserName = pref.getString(g_strUserName, "");

        return strUserName;
    }

    public static void SetUserName(Context context, String strUserName)
    {
        SharedPreferences pref = context.getSharedPreferences(g_strPrefName, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putString(g_strUserName, strUserName);
        editor.commit();

        return;
    }

    public static String GetPass(Context context)
    {
        String strPass = "";

        SharedPreferences pref = context.getSharedPreferences(g_strPrefName, Context.MODE_PRIVATE);
        strPass = pref.getString(g_strPass, "");

        return strPass;
    }

    public static void SetPass(Context context, String strPass)
    {
        SharedPreferences pref = context.getSharedPreferences(g_strPrefName, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putString(g_strPass, strPass);
        editor.commit();

        return;
    }

    public static String unescape(String src)
    {
        StringBuffer tmp = new StringBuffer();
        tmp.ensureCapacity(src.length());
        int  lastPos=0,pos=0;
        char ch;
        while (lastPos<src.length())
        {
            pos = src.indexOf("%",lastPos);
            if (pos == lastPos)
            {
                if (src.charAt(pos+1)=='u')
                {
                    ch = (char)Integer.parseInt(src.substring(pos+2,pos+6),16);
                    tmp.append(ch);
                    lastPos = pos+6;
                }
                else
                {
                    ch = (char)Integer.parseInt(src.substring(pos+1,pos+3),16);
                    tmp.append(ch);
                    lastPos = pos+3;
                }
            }
            else
            {
                if (pos == -1)
                {
                    tmp.append(src.substring(lastPos));
                    lastPos=src.length();
                }
                else
                {
                    tmp.append(src.substring(lastPos,pos));
                    lastPos=pos;
                }
            }
        }
        return tmp.toString();
    }

    public static String encodeWithBase64(Bitmap bitmap)
    {
        if (bitmap == null)
            return "";

        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream);
        byte[] byteArray = stream.toByteArray();
        return Base64.encodeToString(byteArray, Base64.NO_WRAP);
    }
}
