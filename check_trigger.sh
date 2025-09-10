echo "Checking if trigger is working..."
# create tables
mysql -h mysql -u root -ppassword mydatabase < /workspace/sql/create_users_tables.sql
# create trigger
mysql -h mysql -u root -ppassword mydatabase < /workspace/sql/create_trigger_to_users.sql
# insert sample data
mysql -h mysql -u root -ppassword mydatabase < /workspace/sql/insert_users.sql
echo "Trigger check completed. Please verify the user_logs table for entries."