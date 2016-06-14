using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication5
{
    class Blah
    {
        
        public static  int  Blah1(string str,int i)
        {
            string strout = "";
            int x = 0;
            for (int j = 0; j < i; j++)
            {
               
                x = x + str.Length;

                strout = strout + str + "\n";
            }
            MessageBox.Show(strout, "oo");
            return x;  
        }


    }
}
