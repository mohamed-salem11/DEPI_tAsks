using System;

namespace BankAccountApp
{
    class BankAccount
    {
        const string BankCode = "BNK001";
        readonly DateTime CreatedDate;
        private int _accountNumber;
        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private decimal _balance;

        public string FullName
        {
            get { return _fullName; }
            set
            {
                if (string.IsNullOrEmpty(value))
                    throw new ArgumentException("Full name cannot be null or empty");
                _fullName = value;
            }
        }

        public string NationalID
        {
            get { return _nationalID; }
            set
            {
                if (value?.Length != 14 || !IsValidNationalID(value))
                    throw new ArgumentException("National ID must be exactly 14 digits");
                _nationalID = value;
            }
        }

        public string PhoneNumber
        {
            get { return _phoneNumber; }
            set
            {
                if (!IsValidPhoneNumber(value))
                    throw new ArgumentException("Phone number must start with '01' and be 11 digits long");
                _phoneNumber = value;
            }
        }

        public decimal Balance
        {
            get { return _balance; }
            set
            {
                if (value < 0)
                    throw new ArgumentException("Balance must be greater than or equal to 0");
                _balance = value;
            }
        }

        public string Address
        {
            get { return _address; }
            set { _address = value; }
        }

        public int AccountNumber
        {
            get { return _accountNumber; }
            set { _accountNumber = value; }
        }

        public BankAccount()
        {
            CreatedDate = DateTime.Now;
            _fullName = "Default Name";
            _nationalID = "12345678901234";
            _phoneNumber = "01234567890";
            _address = "Default Address";
            _balance = 0;
            _accountNumber = 1001;
        }

        public BankAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance)
        {
            CreatedDate = DateTime.Now;
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Balance = balance;
            _accountNumber = new Random().Next(1000, 9999);
        }

        public BankAccount(string fullName, string nationalID, string phoneNumber, string address)
        {
            CreatedDate = DateTime.Now;
            FullName = fullName;
            NationalID = nationalID;
            PhoneNumber = phoneNumber;
            Address = address;
            Balance = 0;
            _accountNumber = new Random().Next(1000, 9999);
        }

        public void ShowAccountDetails()
        {
            Console.WriteLine("=== Bank Account Details ===");
            Console.WriteLine($"Bank Code: {BankCode}");
            Console.WriteLine($"Account Number: {_accountNumber}");
            Console.WriteLine($"Full Name: {_fullName}");
            Console.WriteLine($"National ID: {_nationalID}");
            Console.WriteLine($"Phone Number: {_phoneNumber}");
            Console.WriteLine($"Address: {_address}");
            Console.WriteLine($"Balance: ${_balance}");
            Console.WriteLine($"Created Date: {CreatedDate}");
            Console.WriteLine("============================\n");
        }

        public bool IsValidNationalID()
        {
            return IsValidNationalID(_nationalID);
        }

        private bool IsValidNationalID(string nationalID)
        {
            if (string.IsNullOrEmpty(nationalID) || nationalID.Length != 14)
                return false;

            foreach (char c in nationalID)
            {
                if (!char.IsDigit(c))
                    return false;
            }
            return true;
        }

        public bool IsValidPhoneNumber()
        {
            return IsValidPhoneNumber(_phoneNumber);
        }

        private bool IsValidPhoneNumber(string phoneNumber)
        {
            if (string.IsNullOrEmpty(phoneNumber))
                return false;

            if (phoneNumber.Length != 11)
                return false;

            if (!phoneNumber.StartsWith("01"))
                return false;

            foreach (char c in phoneNumber)
            {
                if (!char.IsDigit(c))
                    return false;
            }
            return true;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            BankAccount account1 = new BankAccount();

            BankAccount account2 = new BankAccount("Ahmed Mohamed", "12345678901234", "01123456789", "Cairo, Egypt", 5000.50m);

            account1.ShowAccountDetails();
            account2.ShowAccountDetails();

            Console.ReadKey();
        }
    }
}