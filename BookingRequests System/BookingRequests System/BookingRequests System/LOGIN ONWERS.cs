using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace BookingRequests_System
{
    /// <summary>
    /// Login form for pet owners using phone number authentication.
    /// </summary>
    public partial class LOGIN_ONWERS : Form
    {
        private readonly string connectionString = "Data Source=localhost;Initial Catalog=PetCareSolutions;Integrated Security=True";

        public LOGIN_ONWERS()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Handles the login button click event.
        /// Validates the phone number and navigates to booking details if found.
        /// </summary>
        private void button1_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(textBox1.Text))
            {
                MessageBox.Show("Please enter your phone number.", "Input Required", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT id FROM owners WHERE phoneNumber = @phone";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@phone", textBox1.Text);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null)
                        {
                            // Owner found - open the booking details form
                            int ownerId = Convert.ToInt32(result);
                            Booking_details detailsForm = new Booking_details(ownerId);
                            detailsForm.Show();
                            this.Hide();
                        }
                        else
                        {
                            MessageBox.Show("Phone number not found. Please check your number and try again.", "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("An error occurred: " + ex.Message, "System Error", MessageBoxButtons.OK, MessageBoxIcon.Stop);
            }
        }

        private void LOGIN_ONWERS_Load(object sender, EventArgs e)
        {
            // Form load event - reserved for future use
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            // Text changed event - reserved for future use
        }
    }
}
