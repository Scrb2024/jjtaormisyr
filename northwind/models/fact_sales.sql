with stg_orders as (
    select
        orderid,
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
        to_number(to_char(orderdate, 'YYYYMMDD')) as orderdatekey
    from {{ source('northwind', 'Orders') }}
),

stg_order_details as (
    select
        orderid,
        productid,
        quantity,
        unitprice,
        discount,
        quantity * unitprice as extendedpriceamount,
        quantity * unitprice * discount as discountamount,
        (quantity * unitprice) - (quantity * unitprice * discount) as soldamount
    from {{ source('northwind', 'Order_Details') }}
),

fact_sales as (
    select
        od.orderid,
        o.customerkey,
        o.employeekey,
        o.orderdatekey,
        {{ dbt_utils.generate_surrogate_key(['od.productid']) }} as productkey,
        od.quantity,
        od.extendedpriceamount,
        od.discountamount,
        od.soldamount
    from stg_order_details od
    join stg_orders o on o.orderid = od.orderid
)

select * from fact_sales;