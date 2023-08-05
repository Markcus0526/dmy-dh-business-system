package com.damytech.dataclasses;

import org.json.JSONObject;

public class STGoodStatusItem
{
    public long saleid = 0;
	public long goodid = 0;
	public String imgpath = "";
	public String goodname = "";
	public String gooddesc = "";
	public int evalstatus = 0;
	public int salestatus = 0;
	public int rejectstatus = 0;
	public String price = "";
	public String buydate = "";

    public static STGoodStatusItem decode(JSONObject jsonObj)
    {
        STGoodStatusItem goodStatus = new STGoodStatusItem();

        try { goodStatus.saleid = jsonObj.getLong("saleid"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodStatus.goodid = jsonObj.getLong("goodid"); } catch(Exception ex) {ex.printStackTrace();}
        try { goodStatus.imgpath = jsonObj.getString("imgpath"); } catch(Exception ex) {ex.printStackTrace();}
        try { goodStatus.goodname = jsonObj.getString("goodname"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodStatus.gooddesc = jsonObj.getString("gooddesc"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodStatus.evalstatus = jsonObj.getInt("evalstatus"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodStatus.salestatus = jsonObj.getInt("salestatus"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodStatus.rejectstatus = jsonObj.getInt("rejectstatus"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodStatus.price = jsonObj.getString("price"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodStatus.buydate = jsonObj.getString("buydate"); } catch(Exception ex) {ex.printStackTrace();}

        return goodStatus;
    }
}