
create nonclustered index ix_customers_email on sales.customers(email);


create nonclustered index ix_products_category_brand on production.products(category_id, brand_id);


create nonclustered index ix_orders_order_date on sales.orders(order_date) include(customer_id, store_id, order_status);


create table sales.customer_log (
    log_id int identity primary key,
    customer_id int,
    full_name nvarchar(100),
    email nvarchar(255),
    created_at datetime default getdate()
);

select * from sales.customer_log;

CREATE TRIGGER trg_inserted_customer_log
ON sales.customers
AFTER INSERT
AS
BEGIN
    INSERT INTO sales.customer_log(customer_id, action)
    SELECT customer_id, 'insert'
    FROM inserted;
END;


create trigger trg_prevent_category_delete
on production.categories
instead of delete
as
if exists (
    select 1 from deleted d
    join production.products p on d.category_id = p.category_id
)
begin
    raiserror('cannot delete category with associated products.', 16, 1);
end
else
begin
    delete from production.categories
    where category_id in (select category_id from deleted);
end;


create trigger trg_reduce_stockquantity
on sales.order_items
after insert
as
begin
    update s
    set s.quantity = s.quantity - i.quantity
    from production.stocks s
    join inserted i on s.product_id = i.product_id
    join sales.orders o on o.order_id = i.order_id
    where s.store_id = o.store_id;
end;



create trigger trg_log_new_orderr
on sales.orders
after insert
as
begin
    insert into sales.order_audit (
        order_id,
        customer_id,
        store_id,
        staff_id,
        order_date
    )
    select 
        order_id,
        customer_id,
        store_id,
        staff_id,
        order_date
    from inserted;
end;
