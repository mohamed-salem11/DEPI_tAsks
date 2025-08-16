
using ConsoleApp3;

public class Program
{
    public static Bank MyBank { get; private set; }
    private static CancellationTokenSource _cancellationTokenSource;

    public static void Main(string[] args)
    {
        Console.OutputEncoding = System.Text.Encoding.UTF8;
        _cancellationTokenSource = new CancellationTokenSource();

        Task.Run(() => ContinuousGrowthLoop(_cancellationTokenSource.Token));

        Console.WriteLine("Welcome to the Bank System.");
        Console.Write("Please enter the bank name: ");
        string bankName = Console.ReadLine();
        Console.Write("Please enter the branch code: ");
        string branchCode = Console.ReadLine();
        MyBank = new Bank(bankName, branchCode);
        Console.WriteLine($"Bank {MyBank.Name} created successfully.");
        Console.WriteLine("---------------------------------------------");

        while (true)
        {
            Console.WriteLine("\nMain Menu:");
            Console.WriteLine("1. Manage Customers");
            Console.WriteLine("2. Manage Accounts");
            Console.WriteLine("3. Reports");
            Console.WriteLine("4. Exit");
            Console.Write("Please select an option: ");

            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                    ManageCustomers();
                    break;
                case "2":
                    ManageAccounts();
                    break;
                case "3":
                    GenerateReports();
                    break;
                case "4":
                    _cancellationTokenSource.Cancel(); 
                    return;
                default:
                    Console.WriteLine("Invalid option. Please try again.");
                    break;
            }
        }
    }

    public static void ContinuousGrowthLoop(CancellationToken token)
    {
        while (!token.IsCancellationRequested)
        {
            foreach (var customer in MyBank.Customers)
            {
                foreach (var account in customer.Accounts.OfType<SavingAccount>())
                {
                    account.ApplyGrowth();
                }
            }
            Thread.Sleep(100); 
        }
    }

    public static void ManageCustomers()
    {
        while (true)
        {
            Console.WriteLine("\nCustomer Management:");
            Console.WriteLine("1. Add a new customer");
            Console.WriteLine("2. Update customer details");
            Console.WriteLine("3. Remove a customer");
            Console.WriteLine("4. Search for a customer");
            Console.WriteLine("5. Return to Main Menu");
            Console.Write("Please select an option: ");
            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                    AddCustomer();
                    break;
                case "2":
                    UpdateCustomerDetails();
                    break;
                case "3":
                    RemoveCustomer();
                    break;
                case "4":
                    SearchCustomer();
                    break;
                case "5":
                    return;
                default:
                    Console.WriteLine("Invalid option. Please try again.");
                    break;
            }
        }
    }

    public static void ManageAccounts()
    {
        while (true)
        {
            Console.WriteLine("\nAccount Management:");
            Console.WriteLine("1. Add a new account to a customer");
            Console.WriteLine("2. Deposit");
            Console.WriteLine("3. Withdraw");
            Console.WriteLine("4. Transfer");
            Console.WriteLine("5. Return to Main Menu");
            Console.Write("Please select an option: ");
            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                    AddAccountToCustomer();
                    break;
                case "2":
                    PerformDeposit();
                    break;
                case "3":
                    PerformWithdrawal();
                    break;
                case "4":
                    PerformTransfer();
                    break;
                case "5":
                    return;
                default:
                    Console.WriteLine("Invalid option. Please try again.");
                    break;
            }
        }
    }

    public static void GenerateReports()
    {
        while (true)
        {
            Console.WriteLine("\nReports:");
            Console.WriteLine("1. Show a customer's total balance");
            Console.WriteLine("2. Calculate monthly interest for a saving account");
            Console.WriteLine("3. Show comprehensive bank report");
            Console.WriteLine("4. Show transaction history for an account");
            Console.WriteLine("5. Return to Main Menu");
            Console.Write("Please select an option: ");
            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                    ShowCustomerTotalBalance();
                    break;
                case "2":
                    ShowMonthlyInterest();
                    break;
                case "3":
                    ShowBankReport();
                    break;
                case "4":
                    ShowTransactionHistory();
                    break;
                case "5":
                    return;
                default:
                    Console.WriteLine("Invalid option. Please try again.");
                    break;
            }
        }
    }

   
    private static void AddCustomer()
    {
        Console.WriteLine("\nAdd a new customer:");
        Console.Write("Full Name: ");
        string name = Console.ReadLine();
        Console.Write("National ID: ");
        string nationalId = Console.ReadLine();
        Console.Write("Date of Birth (YYYY-MM-DD): ");
        DateTime dob;
        while (!DateTime.TryParse(Console.ReadLine(), out dob))
        {
            Console.WriteLine("Invalid date format. Please try again (YYYY-MM-DD): ");
        }

        var newCustomer = new Customer
        {
            FullName = name,
            NationalId = nationalId,
            DateOfBirth = dob
        };
        MyBank.AddCustomer(newCustomer);
        Console.WriteLine($"Customer {newCustomer.FullName} with ID: {newCustomer.Id} has been added.");
    }

    private static void UpdateCustomerDetails()
    {
        Console.WriteLine("\nUpdate customer details:");
        Console.Write("Please enter the National ID of the customer: ");
        string nationalId = Console.ReadLine();
        var customer = MyBank.Customers.FirstOrDefault(c => c.NationalId == nationalId);

        if (customer == null)
        {
            Console.WriteLine("Customer not found.");
            return;
        }

        Console.WriteLine($"Current details for customer {customer.FullName}:");
        Console.WriteLine($"Name: {customer.FullName}");
        Console.WriteLine($"Date of Birth: {customer.DateOfBirth.ToShortDateString()}");

        Console.Write("New Name (press Enter to keep current): ");
        string newName = Console.ReadLine();
        if (!string.IsNullOrEmpty(newName))
        {
            customer.FullName = newName;
        }

        Console.Write("New Date of Birth (YYYY-MM-DD) (press Enter to keep current): ");
        string newDobStr = Console.ReadLine();
        if (!string.IsNullOrEmpty(newDobStr) && DateTime.TryParse(newDobStr, out DateTime newDob))
        {
            customer.DateOfBirth = newDob;
        }

        Console.WriteLine("Customer details updated successfully.");
    }

    private static void RemoveCustomer()
    {
        Console.WriteLine("\nRemove a customer:");
        Console.Write("Please enter the National ID of the customer to remove: ");
        string nationalId = Console.ReadLine();
        var customer = MyBank.Customers.FirstOrDefault(c => c.NationalId == nationalId);

        if (customer == null)
        {
            Console.WriteLine("Customer not found.");
            return;
        }

        if (customer.Accounts.Any(a => a.Balance > 0))
        {
            Console.WriteLine("Cannot remove the customer because they have accounts with a non-zero balance.");
            return;
        }

        MyBank.Customers.Remove(customer);
        Console.WriteLine($"Customer {customer.FullName} removed successfully.");
    }

    private static void SearchCustomer()
    {
        Console.WriteLine("\nSearch for a customer:");
        Console.WriteLine("1. Search by Name");
        Console.WriteLine("2. Search by National ID");
        Console.Write("Please select an option: ");
        string choice = Console.ReadLine();

        Customer customer = null;
        switch (choice)
        {
            case "1":
                Console.Write("Enter full name: ");
                string name = Console.ReadLine();
                customer = MyBank.Customers.FirstOrDefault(c => c.FullName.Equals(name, StringComparison.OrdinalIgnoreCase));
                break;
            case "2":
                Console.Write("Enter National ID: ");
                string nationalId = Console.ReadLine();
                customer = MyBank.Customers.FirstOrDefault(c => c.NationalId == nationalId);
                break;
            default:
                Console.WriteLine("Invalid option.");
                return;
        }

        if (customer != null)
        {
            Console.WriteLine("---------------------------------------------");
            Console.WriteLine($"Customer: {customer.FullName}");
            Console.WriteLine($"National ID: {customer.NationalId}");
            Console.WriteLine($"Date of Birth: {customer.DateOfBirth.ToShortDateString()}");
            Console.WriteLine("---------------------------------------------");
        }
        else
        {
            Console.WriteLine("Customer not found.");
        }
    }

    private static void AddAccountToCustomer()
    {
        Console.WriteLine("\nAdd a new account to a customer:");
        Console.Write("Please enter the National ID of the customer: ");
        string nationalId = Console.ReadLine();
        var customer = MyBank.Customers.FirstOrDefault(c => c.NationalId == nationalId);

        if (customer == null)
        {
            Console.WriteLine("Customer not found.");
            return;
        }

        Console.WriteLine("Account Type:");
        Console.WriteLine("1. Saving Account");
        Console.WriteLine("2. Current Account");
        Console.Write("Please select an account type: ");
        string typeChoice = Console.ReadLine();

        Console.Write("Please enter the initial deposit amount: ");
        if (!decimal.TryParse(Console.ReadLine(), out decimal initialDeposit))
        {
            Console.WriteLine("Invalid amount.");
            return;
        }

        Account newAccount = null;
        switch (typeChoice)
        {
            case "1":
                newAccount = new SavingAccount(initialDeposit);
                break;
            case "2":
                newAccount = new CurrentAccount(initialDeposit);
                break;
            default:
                Console.WriteLine("Invalid account type.");
                return;
        }

        customer.Accounts.Add(newAccount);
        Console.WriteLine($"New account with number {newAccount.AccountNumber} has been added for customer {customer.FullName}.");
    }

    private static void PerformDeposit()
    {
        Console.WriteLine("\nDeposit funds:");
        Console.Write("Please enter the account number: ");
        string accountNumber = Console.ReadLine();
        var account = MyBank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == accountNumber);

        if (account == null)
        {
            Console.WriteLine("Account not found.");
            return;
        }

        Console.Write("Please enter the amount to deposit: ");
        if (!decimal.TryParse(Console.ReadLine(), out decimal amount))
        {
            Console.WriteLine("Invalid amount.");
            return;
        }

        account.Deposit(amount);
    }

    private static void PerformWithdrawal()
    {
        Console.WriteLine("\nWithdraw funds:");
        Console.Write("Please enter the account number: ");
        string accountNumber = Console.ReadLine();
        var account = MyBank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == accountNumber);

        if (account == null)
        {
            Console.WriteLine("Account not found.");
            return;
        }

        Console.Write("Please enter the amount to withdraw: ");
        if (!decimal.TryParse(Console.ReadLine(), out decimal amount))
        {
            Console.WriteLine("Invalid amount.");
            return;
        }

        account.Withdraw(amount);
    }

    private static void PerformTransfer()
    {
        Console.WriteLine("\nTransfer funds:");
        Console.Write("Please enter the source account number: ");
        string fromAccountNumber = Console.ReadLine();
        var fromAccount = MyBank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == fromAccountNumber);

        if (fromAccount == null)
        {
            Console.WriteLine("Source account not found.");
            return;
        }

        Console.Write("Please enter the destination account number: ");
        string toAccountNumber = Console.ReadLine();
        var toAccount = MyBank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == toAccountNumber);

        if (toAccount == null)
        {
            Console.WriteLine("Destination account not found.");
            return;
        }

        if (fromAccount.AccountNumber == toAccount.AccountNumber)
        {
            Console.WriteLine("You cannot transfer to the same account.");
            return;
        }

        Console.Write("Please enter the amount to transfer: ");
        if (!decimal.TryParse(Console.ReadLine(), out decimal amount))
        {
            Console.WriteLine("Invalid amount.");
            return;
        }

        if (fromAccount.Withdraw(amount))
        {
            toAccount.Deposit(amount);
            fromAccount.AddTransaction(new Transaction(amount, $"Transfer to {toAccount.AccountNumber}"));
            toAccount.AddTransaction(new Transaction(amount, $"Transfer from {fromAccount.AccountNumber}"));
            Console.WriteLine("Transfer successful.");
        }
    }

    private static void ShowCustomerTotalBalance()
    {
        Console.WriteLine("\nShow a customer's total balance:");
        Console.Write("Please enter the National ID of the customer: ");
        string nationalId = Console.ReadLine();
        var customer = MyBank.Customers.FirstOrDefault(c => c.NationalId == nationalId);

        if (customer == null)
        {
            Console.WriteLine("Customer not found.");
            return;
        }

        decimal totalBalance = customer.GetTotalBalance();
        Console.WriteLine($"The total balance for customer {customer.FullName} is: {totalBalance:C}");
    }

    private static void ShowMonthlyInterest()
    {
        Console.WriteLine("\nCalculate monthly interest for a saving account:");
        Console.Write("Please enter the saving account number: ");
        string accountNumber = Console.ReadLine();
        var account = MyBank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == accountNumber) as SavingAccount;

        if (account == null)
        {
            Console.WriteLine("Account not found or is not a saving account.");
            return;
        }

        decimal monthlyInterest = account.CalculateMonthlyInterest();
        Console.WriteLine($"The projected monthly interest for account {account.AccountNumber} is: {monthlyInterest:C}");
    }

    private static void ShowBankReport()
    {
        Console.WriteLine("\nComprehensive Bank Report:");
        Console.WriteLine("---------------------------------------------");
        foreach (var customer in MyBank.Customers)
        {
            Console.WriteLine($"Customer: {customer.FullName} (National ID: {customer.NationalId})");
            foreach (var account in customer.Accounts)
            {
                Console.WriteLine($"  - Account No.: {account.AccountNumber} (Type: {(account is SavingAccount ? "Saving" : "Current")})");
                Console.WriteLine($"    Balance: {account.Balance:C}");
                Console.WriteLine($"    Date Opened: {account.DateOpened.ToShortDateString()}");
            }
            Console.WriteLine($"  Total Customer Balance: {customer.GetTotalBalance():C}");
            Console.WriteLine("---------------------------------------------");
        }
        if (MyBank.Customers.Count == 0)
        {
            Console.WriteLine("There are currently no customers registered.");
        }
    }

    private static void ShowTransactionHistory()
    {
        Console.WriteLine("\nShow transaction history:");
        Console.Write("Please enter the account number: ");
        string accountNumber = Console.ReadLine();
        var account = MyBank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == accountNumber);

        if (account == null)
        {
            Console.WriteLine("Account not found.");
            return;
        }

        Console.WriteLine($"Transaction history for account: {account.AccountNumber}");
        if (account.TransactionHistory.Count == 0)
        {
            Console.WriteLine("No transactions found for this account.");
        }
        else
        {
            foreach (var transaction in account.TransactionHistory.OrderBy(t => t.Timestamp))
            {
                Console.WriteLine($" - {transaction.Timestamp}: {transaction.Type} of {transaction.Amount:C}");
            }
        }
    }
}