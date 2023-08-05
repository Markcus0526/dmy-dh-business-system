package com.damytech.dingshenghui;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STUserInfo;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.ResolutionSet;
import com.damytech.utils.SmartImageView.SmartImage;
import com.damytech.utils.SmartImageView.SmartImageView;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLConnection;
import java.util.Calendar;
import java.util.Date;

public class UserInfoActivity extends SuperActivity implements DialogInterface.OnDismissListener{
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    int nYear = 1900, nMonth = 1, nDay = 1;

    Bitmap bmpPhoto = null;
    String m_szSelPath = "";
    Uri m_szSelUri = null;
    int REQUEST_PHOTO = 0;

    ImageView imgBack = null;
    SmartImageView imgPhoto = null;

    TextView lblMark = null;
    TextView lblBirth = null;
    TextView lblOrder = null;

    EditText txtUserID = null;
    EditText txtUserName = null;
    EditText txtEmail = null;
    EditText txtPhone = null;

    Button btnOk = null;

    STUserInfo stUserInfo = new STUserInfo();
    JsonHttpResponseHandler handlerGetUserInfo = null;
    JsonHttpResponseHandler handlerUpdateUserInfo = null;

    View.OnClickListener onClickListener = new View.OnClickListener()
    {
        @Override
        public void onClick(View v)
        {
            switch (v.getId())
            {
                case R.id.imgBack:
                    finish();
                    break;
                case R.id.btnOk:
                    String strUserName = txtUserName.getText().toString();
                    if (strUserName.length() == 0)
                    {
                        GlobalData.showToast(UserInfoActivity.this, getString(R.string.qingshuruyonghumingcheng));
                        return;
                    }

                    String strBirth = lblBirth.getText().toString();
                    String strEmail = txtEmail.getText().toString();
                    if (strEmail.length() > 0)
                    {
                        if (GlobalData.isValidEmail(strEmail) == false)
                        {
                            GlobalData.showToast(UserInfoActivity.this, getString(R.string.qingshuruzhengquegeshideyouxiangdizhi));
                            return;
                        }
                    }
                    String strPhone = txtPhone.getText().toString();
                    if (strPhone.length() != ConstData.PHONENUM_LENGTH)
                    {
                        GlobalData.showToast(UserInfoActivity.this, getString(R.string.qingshurushiyiweishoujihaoma));

                        return;
                    }

                    startProgress();
                    CommManager.UpdateUserInfo(GlobalData.GetUserID(UserInfoActivity.this), strUserName, strBirth, strEmail, strPhone, GlobalData.encodeWithBase64(bmpPhoto), handlerUpdateUserInfo);
                    break;
                case R.id.lblBirthVal:
                    WheelDatePickerDlg dlgtimepicker = new WheelDatePickerDlg(UserInfoActivity.this);
                    dlgtimepicker.setOnDismissListener(UserInfoActivity.this);
                    dlgtimepicker.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                    dlgtimepicker.setCurDate(new Date(nYear-1900, nMonth-1, nDay));
                    dlgtimepicker.show();
                    break;
                case R.id.txtOrder:
                    Intent intentOrder = new Intent(UserInfoActivity.this, MyOrderListActivity.class);
                    startActivity(intentOrder);
                    break;
                case R.id.imgPhoto:
                    Intent intent = new Intent(UserInfoActivity.this, SelectPhotoActivity.class);
                    startActivityForResult(intent, REQUEST_PHOTO);
                    break;
            }
        }
    };

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_userinfo);

        mainLayout = (RelativeLayout)findViewById(R.id.parent_layout);
        mainLayout.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    public void onGlobalLayout() {
                        if (bInitialized == false)
                        {
                            Rect r = new Rect();
                            mainLayout.getLocalVisibleRect(r);
                            ResolutionSet._instance.setResolution(r.width(), r.height());
                            ResolutionSet._instance.iterateChild(findViewById(R.id.parent_layout));
                            bInitialized = true;
                        }
                    }
                }
        );

        initControl();
        initHandler();

        startProgress();
        CommManager.GetUserInfo(GlobalData.GetUserID(UserInfoActivity.this), handlerGetUserInfo);
    }

    private void initControl()
    {
        nYear = Calendar.getInstance().get(Calendar.YEAR);
        nMonth = Calendar.getInstance().get(Calendar.MONTH);
        nDay = Calendar.getInstance().get(Calendar.DAY_OF_MONTH);

        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);

        imgPhoto = (SmartImageView)findViewById(R.id.imgPhoto);
        imgPhoto.setOnClickListener(onClickListener);
        imgPhoto.isCircular = true;
        imgPhoto.setScaleType(ImageView.ScaleType.FIT_XY);
        imgPhoto.setImage(new SmartImage() {
            @Override
            public Bitmap getBitmap(Context context) {
                return BitmapFactory.decodeResource(getResources(), R.drawable.mainicon);
            }
        });

        lblMark = (TextView) findViewById(R.id.lblMark);

        btnOk = (Button) findViewById(R.id.btnOk);
        btnOk.setOnClickListener(onClickListener);

        lblBirth = (TextView) findViewById(R.id.lblBirthVal);
        lblBirth.setOnClickListener(onClickListener);
        lblOrder = (TextView) findViewById(R.id.txtOrder);
        lblOrder.setOnClickListener(onClickListener);

        txtUserID = (EditText) findViewById(R.id.txtUserID);
        txtUserName = (EditText) findViewById(R.id.txtUserName);
        txtEmail = (EditText) findViewById(R.id.txtEmail);
        txtPhone = (EditText) findViewById(R.id.txtPhone);

        return;
    }

    private void initHandler()
    {
        handlerGetUserInfo = new JsonHttpResponseHandler()
        {
            @Override
            public void onSuccess(JSONObject jsonData)
            {
                stopProgress();

                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        String baseAddress = jsonData.getString("BASEURL");
                        stUserInfo = STUserInfo.decode(jsonData.getJSONObject("RETDATA"));

                        lblMark.setText(stUserInfo.userid + getString(R.string.dejifen) + " : " + stUserInfo.credit);
                        txtUserID.setText(stUserInfo.userid);
                        txtUserName.setText(stUserInfo.username);
                        txtEmail.setText(stUserInfo.email);
                        lblOrder.setText("" + stUserInfo.ordercount + getString(R.string.bi));
                        txtPhone.setText(stUserInfo.phonenum);
                        lblBirth.setText(stUserInfo.birth);
                        nYear = Integer.parseInt(stUserInfo.birth.substring(0, 4));
                        nMonth = Integer.parseInt(stUserInfo.birth.substring(5, 7));
                        nDay = Integer.parseInt(stUserInfo.birth.substring(8, 10));
                        imgPhoto.setImageUrl(baseAddress + stUserInfo.imgpath, R.drawable.mainicon);
                    }
                    else if (nRetCode == ConstData.ERR_NOTEXISTUSER)
                    {
                        GlobalData.showToast(UserInfoActivity.this, getString(R.string.notexistuser));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(UserInfoActivity.this, getString(R.string.fuwuqineibucuowu));

                        return;
                    }
                }
                catch (Exception ex)
                {
                    ex.printStackTrace();
                };
            }

            @Override
            public void onFailure(Throwable error, String content) {
                super.onFailure(error, content);
                GlobalData.showToast(UserInfoActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        handlerUpdateUserInfo = new JsonHttpResponseHandler()
        {
            @Override
            public void onSuccess(JSONObject jsonData)
            {
                stopProgress();

                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        GlobalData.showToast(UserInfoActivity.this, getString(R.string.caozuochenggong));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_NOTEXISTUSER)
                    {
                        GlobalData.showToast(UserInfoActivity.this, getString(R.string.notexistuser));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_EXISTEDPHONE)
                    {
                        GlobalData.showToast(UserInfoActivity.this, getString(R.string.existedphone));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(UserInfoActivity.this, getString(R.string.fuwuqineibucuowu));

                        return;
                    }
                }
                catch (Exception ex)
                {
                    ex.printStackTrace();
                };
            }

            @Override
            public void onFailure(Throwable error, String content) {
                super.onFailure(error, content);
                GlobalData.showToast(UserInfoActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        if (dialog.getClass() == WheelDatePickerDlg.class)
        {
            WheelDatePickerDlg convDlg = (WheelDatePickerDlg) dialog;

            nYear = convDlg.getYear();
            nMonth = convDlg.getMonth();
            nDay = convDlg.getDay();

            String strDateTime = String.format("%04d-%02d-%02d", nYear, nMonth, nDay);
            lblBirth.setText(strDateTime);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data); // To change body

        if (requestCode == REQUEST_PHOTO && resultCode == RESULT_OK)
            updateUserImage(data);
    }

    private void updateUserImage(Intent data)
    {
        if (data.getIntExtra(SelectPhotoActivity.szRetCode, -999) == SelectPhotoActivity.nRetSuccess)
        {
            Object objPath = data.getExtras().get(SelectPhotoActivity.szRetPath);

            String szPath = "";
            if (objPath != null)
                szPath = (String)objPath;

            if (szPath != null && !szPath.equals(""))
            {
                updateUserImageWithPath(szPath);
            }
        }
    }

    private void updateUserImageWithPath(String szPath)
    {
        try {
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inPreferredConfig = Bitmap.Config.ARGB_8888;
            Bitmap bitmap = BitmapFactory.decodeFile(szPath, options);

            if (bitmap != null)
            {
                int nWidth = bitmap.getWidth(), nHeight = bitmap.getHeight();
                int nScaledWidth = 0, nScaledHeight = 0;
                if (nWidth > nHeight)
                {
                    nScaledWidth = SelectPhotoActivity.IMAGE_WIDTH;
                    nScaledHeight = nScaledWidth * nHeight / nWidth;
                }
                else
                {
                    nScaledHeight = SelectPhotoActivity.IMAGE_HEIGHT;
                    nScaledWidth = nScaledHeight * nWidth / nHeight;
                }
                bmpPhoto = Bitmap.createScaledBitmap(bitmap, nScaledWidth, nScaledHeight, false);
                imgPhoto.setImage(new SmartImage() {
                    @Override
                    public Bitmap getBitmap(Context context) {
                        return bmpPhoto;
                    }
                });
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void updateUserImageWithUri(Uri uri, boolean isPhoto)
    {
        BufferedInputStream bis = null;
        InputStream is = null;
        Bitmap bmp = null;
        URLConnection conn = null;

        startProgress();

        try {
            String szUrl = uri.toString();

            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inPreferredConfig = Bitmap.Config.ARGB_8888;

            is = getContentResolver().openInputStream(uri);
            bmp = BitmapFactory.decodeStream(is, null, options);

            int nWidth = bmp.getWidth(), nHeight = bmp.getHeight();
            int nScaledWidth = 0, nScaledHeight = 0;
            if (nWidth > nHeight)
            {
                nScaledWidth = SelectPhotoActivity.IMAGE_WIDTH;
                nScaledHeight = nScaledWidth * nHeight / nWidth;
            }
            else
            {
                nScaledHeight = SelectPhotoActivity.IMAGE_HEIGHT;
                nScaledWidth = nScaledHeight * nWidth / nHeight;
            }

            bmpPhoto = Bitmap.createScaledBitmap(bmp, nScaledWidth, nScaledHeight, false);
            imgPhoto.setImageBitmap(bmpPhoto);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        finally {
            stopProgress();
            if (bis != null) {
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static int computeSampleSize(BitmapFactory.Options options,
                                        int minSideLength, int maxNumOfPixels) {
        int initialSize = computeInitialSampleSize(options, minSideLength,
                maxNumOfPixels);

        int roundedSize;
        if (initialSize <= 8) {
            roundedSize = 1;
            while (roundedSize < initialSize) {
                roundedSize <<= 1;
            }
        } else {
            roundedSize = (initialSize + 7) / 8 * 8;
        }

        return roundedSize;
    }

    private static int computeInitialSampleSize(BitmapFactory.Options options,
                                                int minSideLength, int maxNumOfPixels) {
        double w = options.outWidth;
        double h = options.outHeight;

        int lowerBound = (maxNumOfPixels == -1) ? 1 : (int) Math.ceil(Math
                .sqrt(w * h / maxNumOfPixels));
        int upperBound = (minSideLength == -1) ? 128 : (int) Math.min(Math
                .floor(w / minSideLength), Math.floor(h / minSideLength));

        if (upperBound < lowerBound) {
            return lowerBound;
        }

        if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
            return 1;
        } else if (minSideLength == -1) {
            return lowerBound;
        } else {
            return upperBound;
        }
    }

    private void onClickSelectPhoto() {
        Intent intent = new Intent(this, SelectPhotoActivity.class);
        startActivityForResult(intent, REQUEST_PHOTO);
    }
}
