using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace BookingRequests_System
{
    /// <summary>
    /// Form for submitting pet care booking requests.
    /// </summary>
    public partial class Booking_details : Form
    {
        private readonly string connectionString = "Data Source=localhost;Initial Catalog=PetCareSolutions;Integrated Security=True";
        private readonly int currentOwnerId;

        /// <summary>
        /// Initializes the booking details form with the owner's ID.
        /// </summary>
        /// <param name="ownerId">The ID of the logged-in pet owner.</param>
        public Booking_details(int ownerId)
        {
            InitializeComponent();
            currentOwnerId = ownerId;
        }

        /// <summary>
        /// Handles form load event - configures controls and loads pet data.
        /// </summary>
        private void Booking_details_Load(object sender, EventArgs e)
        {
            // Configure the time picker format
            dateTimePicker2.Format = DateTimePickerFormat.Custom;
            dateTimePicker2.CustomFormat = "hh:mm tt"; // e.g., 02:30 PM
            dateTimePicker2.ShowUpDown = true;

            // Load this owner's pets into the dropdown
            LoadMyPets();
        }

        /// <summary>
        /// Loads the pet list for the current owner into the combo box.
        /// </summary>
        private void LoadMyPets()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    string query = "SELECT id, name FROM pets WHERE ownerId = @ownerId";
                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    adapter.SelectCommand.Parameters.AddWithValue("@ownerId", currentOwnerId);

                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    comboBox1.DataSource = dt;
                    comboBox1.DisplayMember = "name";
                    comboBox1.ValueMember = "id";
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Failed to load your pets: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        /// <summary>
        /// Handles the submit booking request button click.
        /// </summary>
        private void button1_Click(object sender, EventArgs e)
        {
            if (comboBox1.SelectedValue == null)
            {
                MessageBox.Show("Please select a pet.", "Input Required", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            int petId = Convert.ToInt32(comboBox1.SelectedValue);
            DateTime requestedDate = dateTimePicker1.Value;
            TimeSpan requestedTime = dateTimePicker2.Value.TimeOfDay;

            string query = "INSERT INTO BookingRequests (OwnerID, PetID, RequestedDate, RequestedTime, Status) VALUES (@ownerId, @petId, @reqDate, @reqTime, 'Pending')";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ownerId", currentOwnerId);
                    cmd.Parameters.AddWithValue("@petId", petId);
                    cmd.Parameters.AddWithValue("@reqDate", requestedDate.Date);
                    cmd.Parameters.AddWithValue("@reqTime", requestedTime);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        MessageBox.Show("Your booking request has been sent successfully!", "Request Sent", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        this.Close();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Error sending request: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Selection changed event - reserved for future use
        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {
            // Date picker value changed - reserved for future use
        }

        private void dateTimePicker2_ValueChanged(object sender, EventArgs e)
        {
            // Time picker value changed - reserved for future use
        }
    }
}
