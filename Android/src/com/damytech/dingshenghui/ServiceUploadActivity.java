package com.damytech.dingshenghui;

import android.app.Service;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.*;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.ResolutionSet;
import org.json.JSONObject;

public class ServiceUploadActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    final int MODE_BANK = 0;
    final int MODE_CREDIT = 1;
    final int MODE_INSURANCE = 2;
    final int MODE_PROPERTY = 3;
    final int MODE_SMALLMONEY = 4;
    int nMode = MODE_BANK;
    long nCardID = 0;

    ImageView imgBack;
    Button btnNext;
    TextView lblTitle;
    EditText txtName;
    EditText txtPhone;
    EditText txtIDCard;
    EditText txtAddress;
    EditText txtNote;

    JsonHttpResponseHandler handler = null;

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
                case R.id.btnNext:
                    String strName = txtName.getText().toString();
                    if (strName.length() == 0)
                    {
                        GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.qingshuruyonghuming));
                        return;
                    }
                    String strPhone = txtPhone.getText().toString();
                    if (strPhone.length() == 0)
                    {
                        GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.qingshurudianhuahaoma));
                        return;
                    }
                    String strAddress = txtAddress.getText().toString();
                    if (strAddress.length() == 0)
                    {
                        GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.qingshurudizhi));
                        return;
                    }
                    String strCardID = txtIDCard.getText().toString();
                    if (strCardID.length() == 0)
                    {
                        GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.qingshurushenfenzhenghaoma));
                        return;
                    }
                    String strNote = txtNote.getText().toString();

                    startProgress();
                    CommManager.AddServiceItem(GlobalData.GetUserID(ServiceUploadActivity.this),
                            nMode,
                            nCardID,
                            strName,
                            strPhone,
                            strCardID,
                            strAddress,
                            strNote,
                            handler);
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
        setContentView(R.layout.activity_serviceupload);

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

        nMode = getIntent().getIntExtra("MODE", MODE_BANK);
        switch (nMode)
        {
            case MODE_BANK:
                lblTitle.setText(getString(R.string.yinhangkashouli));
                break;
            case MODE_CREDIT:
                lblTitle.setText(getString(R.string.xinyongkabanli));
                break;
            case MODE_INSURANCE:
                lblTitle.setText(getString(R.string.baoxianyewu));
                break;
            case MODE_PROPERTY:
                lblTitle.setText(getString(R.string.licaichanpin));
                break;
            case MODE_SMALLMONEY:
                lblTitle.setText(getString(R.string.xiaoedaikuan));
                break;
        }
        nCardID = getIntent().getLongExtra("UID", 0);
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);

        lblTitle = (TextView) findViewById(R.id.lblTitle);

        btnNext = (Button) findViewById(R.id.btnNext);
        btnNext.setOnClickListener(onClickListener);

        txtName = (EditText) findViewById(R.id.txtName);
        txtPhone = (EditText) findViewById(R.id.txtPhone);
        txtIDCard = (EditText) findViewById(R.id.txtIDCard);
        txtAddress = (EditText) findViewById(R.id.txtAddress);
        txtNote = (EditText) findViewById(R.id.txtContent);

        return;
    }

    private void initHandler()
    {
        handler = new JsonHttpResponseHandler()
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
                        GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.caozuochenggong));

                        Intent intent = new Intent(ServiceUploadActivity.this, FinanceActivity.class);
                        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_NOTEXISTUSER)
                    {
                        GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.notexistuser));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_INVALIDPARAM)
                    {
                        GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.notexistcardinfo));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.fuwuqineibucuowu));

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
                GlobalData.showToast(ServiceUploadActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }
}
