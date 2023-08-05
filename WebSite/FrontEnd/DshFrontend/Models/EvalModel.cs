using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DshFrontend.Models.Library;
using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Globalization;

namespace DshFrontend.Models
{
    public class EvalInfo
    {
        public long uid { get; set; }
        public long catalog_id { get; set; }
        public string catalog_name { get; set; }
        public string catalog_image { get; set; }
        public byte eval { get; set; }
    }

    public class EvalModel
    {
        DshDBModelDataContext db = new DshDBModelDataContext();

        public tbl_eval GetEvalById(long uid)
        {
            return db.tbl_evals
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
        }

        public tbl_eval GetEvalBySaleId(long sale_id)
        {
            return db.tbl_evals
                .Where(m => m.deleted == 0 && m.sid == sale_id)
                .FirstOrDefault();
        }

        public byte GetEvalValueBySaleId(long sale_id)
        {
            var item = GetEvalBySaleId(sale_id);
            if (item != null)
                return (byte)item.eval;
            else
                return 0;
        }

        //public tbl_eval GetEvalByCatalogIdAndUser(long catalog_id, long user_id)
        //{
        //    return db.tbl_evals
        //        .Where(m => m.deleted == 0 && m.catalogid == catalog_id && m.userid == user_id)
        //        .FirstOrDefault();
        //}

        //public byte GetEvalValueByCatalogIdAndUser(long catalog_id, long user_id)
        //{
        //    var item = GetEvalByCatalogIdAndUser(catalog_id, user_id);
        //    if (item != null)
        //        return (byte)item.eval;
        //    else
        //        return 0;
        //}

        //public string InsertOrUpdateEval(long catalog_id, long user_id, int eval)
        //{
        //    string rst = "";
        //    tbl_eval edititem = GetEvalByCatalogIdAndUser(catalog_id, user_id);

        //    if (edititem != null)
        //    {
        //        edititem.eval = eval;

        //        db.SubmitChanges();
        //        rst = "";
        //    }
        //    else
        //    {
        //        tbl_eval newitem = new tbl_eval();

        //        newitem.catalogid = catalog_id;
        //        newitem.eval = eval;
        //        newitem.userid = user_id;
        //        newitem.regtime = DateTime.Now;

        //        db.tbl_evals.InsertOnSubmit(newitem);

        //        db.SubmitChanges();
        //    }

        //    return rst;
        //}

        public string InsertOrUpdateEval(long sale_id, long catalog_id, int eval)
        {
            string rst = "";
            tbl_eval edititem = GetEvalBySaleId(sale_id);

            if (edititem != null)
            {
                edititem.eval = eval;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                tbl_eval newitem = new tbl_eval();

                newitem.sid = sale_id;
                newitem.catalogid = catalog_id;
                newitem.eval = eval;
                newitem.userid = CommonModel.GetCurrentUserId();
                newitem.regtime = DateTime.Now;

                db.tbl_evals.InsertOnSubmit(newitem);

                db.SubmitChanges();
            }

            return rst;
        }

        public string UpdateEval(long uid, int eval)
        {
            string rst = "";
            tbl_eval edititem = GetEvalById(uid);

            if (edititem != null)
            {
                edititem.eval = eval;

                db.SubmitChanges();
                rst = "";
            }
            else
            {
                rst = "错误";
            }

            return rst;
        }

        public static decimal GetCatalogEval(long catalogid)
        {
            decimal eval = 0;

            DshDBModelDataContext db1 = new DshDBModelDataContext();

            int count = (from m in db1.tbl_evals
                         where m.deleted == 0 && m.catalogid == catalogid
                         select m).Count();
            if (count != 0)
            {
                decimal sum = (from m in db1.tbl_evals
                               where m.deleted == 0 && m.catalogid == catalogid
                               select m.eval).Sum();
                eval = sum / count;
            }            

            return eval;
        }

        public static List<decimal> GetCatalogRatingList(long kindid, int pagenum, int type, String search_txt)
        {
            List<GoodsCatalogList> list = CatalogModel.GetCatalogListWithKindPagenum(kindid, pagenum, type, search_txt);

            List<decimal> rst = new List<decimal>();

            if (list != null)
            {
                for (int i = 0; i < list.Count; i++)
                {
                    rst.Add(GetCatalogEval(list.ElementAt(i).uid));
                }
                return rst;
            }
            else
                return null;
        }

        //public EvalInfo GetEvalInfoByCatalogIdAndUserId(long catalog_id, long user_id)
        //{
        //    var evalitem = GetEvalByCatalogIdAndUser(catalog_id, user_id);
        //    CatalogModel catalogModel = new CatalogModel();
        //    var catalogitem = catalogModel.GetCatalogById(catalog_id);
        //    if (catalogitem != null)
        //        return new EvalInfo
        //        {
        //            uid = evalitem!=null?evalitem.uid:0,
        //            eval = (byte)(evalitem!=null?evalitem.eval:0),
        //            catalog_id = catalogitem.uid,
        //            catalog_name = catalogitem.name,
        //            catalog_image = catalogitem.image1
        //        };
        //    else
        //        return null;
        //}

        public EvalInfo GetEvalInfoBySaleId(long sale_id, long catalog_id)
        {
            var evalitem = GetEvalBySaleId(sale_id);
            CatalogModel catalogModel = new CatalogModel();
            var catalogitem = catalogModel.GetCatalogById(catalog_id);
            if (catalogitem != null)
                return new EvalInfo
                {
                    uid = evalitem != null ? evalitem.uid : 0,
                    eval = (byte)(evalitem != null ? evalitem.eval : 0),
                    catalog_id = catalogitem.uid,
                    catalog_name = catalogitem.name,
                    catalog_image = catalogitem.image1
                };
            else
                return null;
        }
    }
}
