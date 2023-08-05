using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Globalization;
using DshBackend.Models.Library;

namespace DshBackend.Models
{
    public class EvalModel
    {
        static DshDBModelDataContext db = new DshDBModelDataContext();

        public static decimal GetEvalValueByCatalogId(long catalog_id)
        {
            var list = db.tbl_evals
                .Where(m => m.deleted == 0 && m.catalogid == catalog_id)
                .ToList();
            if (list.Count() > 0)
                return list.Average(m => m.eval);
            else
                return 0;
        }

    }
}
