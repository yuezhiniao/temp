using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication3
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox1.Checked==true)
            {
                MessageBox.Show("check");
            }
            else
            {
                MessageBox.Show("not check");
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            


                if (checkBox1.Checked == true && label2.BackColor != Color.Red)
                {
                    label2.BackColor = Color.Red;
                }
                else if(checkBox1.Checked == true  )
                {
                    label2.BackColor = Color.Blue;
                }

            

           
        }
    }
}
