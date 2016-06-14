using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication2
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string name = "yue";
            int x = 3;
            x = x * 17;
            double d = Math.PI / 2;
            MessageBox.Show("name is " + name + "\nx is " + x + "\nd is " + d);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            int x = 5;
            if (x==10)
            {
                MessageBox.Show("x is must be 10 ");

            }
            else
            {
                MessageBox.Show("x is must be 5 ");
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            int i = 66;
            string name = "yue";
            if (name=="fd" && i == 45)
            {
                MessageBox.Show("name , i");
            }
            else
            {
                MessageBox.Show("name=yue, i=66");
            }

        }

        private void button4_Click(object sender, EventArgs e)
        {
            int count = 0;
            while (count<5)
            {
                count = count +1;
                for (int i = 0; i < 5; i++)
                {
                    count = count - 1;

                }

                MessageBox.Show("out"+count);
            }
        }
    }
}
