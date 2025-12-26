using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace bitcINTERFACE
{
    public partial class login : Form
    {
        private string connectionString = "Data Source=localhost;Initial Catalog=PetCareSolutions;Integrated Security=True";

        public login()
        {
             InitializeComponent();
            textBox2.PasswordChar = '*';
        }

        private void login_Load(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(textBox1.Text) || string.IsNullOrWhiteSpace(textBox2.Text))
            {
                MessageBox.Show("Please enter username and password.", "Input Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // SQL query to find the user
                    string query = "SELECT passwordHash, role FROM users WHERE username = @username";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@username", textBox1.Text);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        // Check if the user was found
                        if (reader.Read())
                        {
                            string storedPasswordHash = reader["passwordHash"].ToString();
                            string retrievedUserRole = reader["role"].ToString(); // Renamed variable to avoid conflict

                            // 4. Compare the password (simplified)
                            // Note: In a real system, you should compare the hash, not the plain text.
                            if (textBox2.Text == storedPasswordHash)
                            {
                                // 5. If login is successful
                                MessageBox.Show($"Login successful. Welcome, {retrievedUserRole}!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);

                                string userRole = reader["role"].ToString();
                                string username = textBox1.Text; // اسم المستخدم من مربع النص

                                // التعديل هنا: نرسل الاسم والدور معاً
                                Dashboard dashboardForm = new Dashboard(userRole, username);
                                dashboardForm.Show();

                                this.Hide();

                            }
                            else
                            {
                                // Incorrect password
                                MessageBox.Show("Incorrect password.", "Login Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            }
                        }
                        else
                        {
                            // Username not found
                            MessageBox.Show("Username not found.", "Login Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // To handle any other errors (like a database connection issue)
                MessageBox.Show("An error occurred during login: " + ex.Message, "Technical Error", MessageBoxButtons.OK, MessageBoxIcon.Stop);
            }
        }
    }
}
