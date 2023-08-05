package com.damytech.dingshenghui;

import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.HorizontalPager;
import com.damytech.utils.ResolutionSet;
import org.json.JSONObject;

public class SmallMoneyUploadActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    int nMode = 0;
    long nCardID = 0;

    ImageView imgBack;
    HorizontalPager hor_pager = null;
    RelativeLayout indicator_layout = null;
    RelativeLayout rlPersonal = null, rlBusiness = null;
    TextView lblPersonal = null, lblBusiness = null;
    ImageButton btnPersonal = null, btnBusiness = null;

    EditText txtBusinessName = null;
    EditText txtCorporateMan = null;
    EditText txtCorporateID = null;
    EditText txtCorporatePhone = null;
    EditText txtUserName = null;
    EditText txtUserPhone = null;
    EditText txtUserAddress = null;
    EditText txtBusinessContent = null;

    EditText txtName;
    EditText txtPhone;
    EditText txtIDCard;
    EditText txtAddress;
    EditText txtNote;

    Button btnPerson;
    Button btnBusinessNext;

    JsonHttpResponseHandler handlerPerson = null;
    JsonHttpResponseHandler handlerBusiness = null;

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
                case R.id.btnTabPersonal:
                    hor_pager.setCurrentScreen(0, true);
                    break;
                case R.id.btnTabBusiness:
                    hor_pager.setCurrentScreen(1, true);
                    break;
                case R.id.btnNext:
                    String strName = txtName.getText().toString();
                    if (strName.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshuruyonghuming));
                        return;
                    }
                    String strPhone = txtPhone.getText().toString();
                    if (strPhone.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurudianhuahaoma));
                        return;
                    }
                    String strAddress = txtAddress.getText().toString();
                    if (strAddress.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurudizhi));
                        return;
                    }
                    String strCardID = txtIDCard.getText().toString();
                    if (strCardID.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurushenfenzhenghaoma));
                        return;
                    }
                    String strNote = txtNote.getText().toString();

                    startProgress();
                    CommManager.AddServiceItem(GlobalData.GetUserID(SmallMoneyUploadActivity.this),
                            nMode,
                            nCardID,
                            strName,
                            strPhone,
                            strCardID,
                            strAddress,
                            strNote,
                            handlerPerson);
                    break;
                case R.id.btnBusinessNext:
                    String businessname = txtBusinessName.getText().toString();
                    if (businessname.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurujiekuanqiyemingcheng));
                        return;
                    }
                    String corporateman = txtCorporateMan.getText().toString();
                    if (corporateman.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshuruqiyefarenmingcheng));
                        return;
                    }
                    String corporateid = txtCorporateID.getText().toString();
                    if (corporateid.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurufarenshenfenzhenghao));
                        return;
                    }
                    String corporatephone = txtCorporatePhone.getText().toString();
                    if (corporatephone.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurufarenlianxifangshi));
                        return;
                    }
                    String username = txtUserName.getText().toString();
                    if (username.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurulianxiren));
                        return;
                    }
                    String userphone = txtUserPhone.getText().toString();
                    if (userphone.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurulianxifangshi));
                        return;
                    }
                    String useraddress = txtUserAddress.getText().toString();
                    if (useraddress.length() == 0)
                    {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.qingshurulianxidizhi));
                        return;
                    }
                    String usercontent = txtBusinessContent.getText().toString();

                    startProgress();
                    CommManager.AddBusinessMoney(GlobalData.GetUserID(SmallMoneyUploadActivity.this),
                                                 nCardID,
                                                businessname,
                                                corporateman,
                                                corporateid,
                                                corporatephone,
                                                username,
                                                userphone,
                                                useraddress,
                                                usercontent,
                                                handlerBusiness);
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
        setContentView(R.layout.activity_smallmoneyupload);

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

        nMode = getIntent().getIntExtra("MODE", 0);
        nCardID = getIntent().getLongExtra("UID", 0);

        initControl();
        initHandler();
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);

        hor_pager = (HorizontalPager)findViewById(R.id.viewPager);
        hor_pager.setVisibility(View.VISIBLE);
        hor_pager.setScrollChangeListener(new HorizontalPager.OnHorScrolledListener()
        {
            @Override
            public void onScrolled() {
                controlIndicatorPos();
            }
        });

        rlPersonal = (RelativeLayout) findViewById(R.id.rlPersonal);
        rlPersonal.setVisibility(View.VISIBLE);

        rlBusiness = (RelativeLayout) findViewById(R.id.rlBusiness);
        rlBusiness.setVisibility(View.VISIBLE);

        ViewGroup parentView = null;
        parentView = (ViewGroup) rlPersonal.getParent();
        parentView.removeView(rlPersonal);

        parentView = (ViewGroup) rlBusiness.getParent();
        parentView.removeView(rlBusiness);

        hor_pager.addView(rlPersonal);
        hor_pager.addView(rlBusiness);
        hor_pager.setCurrentScreen(0, true);

        indicator_layout = (RelativeLayout)findViewById(R.id.page_indicator);

        lblPersonal = (TextView) findViewById(R.id.lblPersonal);
        lblBusiness = (TextView) findViewById(R.id.lblBusiness);

        btnPersonal = (ImageButton) findViewById(R.id.btnTabPersonal);
        btnPersonal.setOnClickListener(onClickListener);
        btnBusiness = (ImageButton) findViewById(R.id.btnTabBusiness);
        btnBusiness.setOnClickListener(onClickListener);

        btnPerson = (Button) findViewById(R.id.btnNext);
        btnPerson.setOnClickListener(onClickListener);
        btnBusinessNext = (Button) findViewById(R.id.btnBusinessNext);
        btnBusinessNext.setOnClickListener(onClickListener);

        txtName = (EditText) findViewById(R.id.txtName);
        txtPhone = (EditText) findViewById(R.id.txtPhone);
        txtIDCard = (EditText) findViewById(R.id.txtIDCard);
        txtAddress = (EditText) findViewById(R.id.txtAddress);
        txtNote = (EditText) findViewById(R.id.txtContent);

        txtBusinessName = (EditText) findViewById(R.id.txtBusinessName);
        txtCorporateMan = (EditText) findViewById(R.id.txtCorporateMan);
        txtCorporateID = (EditText) findViewById(R.id.txtCorporateIDCard);
        txtCorporatePhone = (EditText) findViewById(R.id.txtCorporatePhone);
        txtUserName = (EditText) findViewById(R.id.txtUserName);
        txtUserPhone = (EditText) findViewById(R.id.txtUserPhone);
        txtUserAddress = (EditText) findViewById(R.id.txtUserAddress);
        txtBusinessContent = (EditText) findViewById(R.id.txtBusinessContent);

        return;
    }

    private void initHandler()
    {
        handlerBusiness = new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(JSONObject jsonData) {
                stopProgress();

                try {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS) {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.caozuochenggong));

                        Intent intent = new Intent(SmallMoneyUploadActivity.this, FinanceActivity.class);
                        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);

                        return;
                    } else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR) {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.fuwuqineibucuowu));
                        return;
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }

            @Override
            public void onFailure(Throwable error, String content) {
                super.onFailure(error, content);
                GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        handlerPerson = new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(JSONObject jsonData) {
                stopProgress();

                try {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS) {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.caozuochenggong));

                        Intent intent = new Intent(SmallMoneyUploadActivity.this, FinanceActivity.class);
                        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);

                        return;
                    } else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR) {
                        GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.fuwuqineibucuowu));
                        return;
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }

            @Override
            public void onFailure(Throwable error, String content) {
                super.onFailure(error, content);
                GlobalData.showToast(SmallMoneyUploadActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }

    private void controlIndicatorPos()
    {
        if (indicator_layout == null)
            return;

        int nScrollX = hor_pager.getScrollX();
        int nPageWidth = hor_pager.getWidth();

        int nIndicatorWidth = indicator_layout.getWidth();
        if (nIndicatorWidth == 0) {
            return;
        }

        int nTabItemWidth = 360;
        RelativeLayout.LayoutParams layout_params = new RelativeLayout.LayoutParams(nTabItemWidth, 3);
        layout_params.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        layout_params.leftMargin = nTabItemWidth * nScrollX / nPageWidth;

        indicator_layout.setLayoutParams(layout_params);
        ResolutionSet._instance.iterateChild(indicator_layout);

        if (nScrollX < nPageWidth / 2)
        {
            lblPersonal.setTextColor(getResources().getColor(R.color.bluelight));
            lblBusiness.setTextColor(getResources().getColor(R.color.gray));
        }
        else
        {
            lblPersonal.setTextColor(getResources().getColor(R.color.gray));
            lblBusiness.setTextColor(getResources().getColor(R.color.bluelight));
        }
    }
}
