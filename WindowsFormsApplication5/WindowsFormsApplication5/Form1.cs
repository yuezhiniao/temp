using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication5
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            int x;
            x = Blah.Blah1(textBox1.Text,(int)numericUpDown1.Value);
           
           MessageBox.Show( "length is "+x,"length");

            Console.WriteLine(textBox1.Size);
        }
    }
}
