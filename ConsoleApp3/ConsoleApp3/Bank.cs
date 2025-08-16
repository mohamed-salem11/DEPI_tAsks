using ConsoleApp3;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp3
{
    public class Bank
    {
        public string Name { get; set; }
        public string BranchCode { get; set; }
        public List<Customer> Customers { get; set; } = new List<Customer>();
        public static int CustomerCounter = 1;
        public static int AccountNumberCounter = 1000;

        public Bank(string name, string branchCode)
        {
            Name = name;
            BranchCode = branchCode;
        }

        // Adds a new customer
        public void AddCustomer(Customer customer)
        {
            customer.Id = CustomerCounter++;
            Customers.Add(customer);
        }
    }
}
