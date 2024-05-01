drop table if exists categorias;
create table categorias(
	codigo_cat serial not null,
	nombre varchar(100) not null,
	categoria_padre int,
	constraint categorias_pk primary key (codigo_cat),
	constraint categorias_fk foreign key (categoria_padre) 
	references categorias(codigo_cat)
);

insert into categorias(nombre,categoria_padre)
values('Materia Prima', null);

insert into categorias(nombre,categoria_padre)
values('Proteina', 1);

insert into categorias(nombre,categoria_padre)
values('Salsas', 1);

insert into categorias(nombre,categoria_padre)
values('Punto de Venta', null);

insert into categorias(nombre,categoria_padre)
values('Bebidas', 4);

insert into categorias(nombre,categoria_padre)
values('Con alcohol', 5);

insert into categorias(nombre,categoria_padre)
values('Sin alcohol', 5);


select * from categorias;
--------------------------------
drop table if exists categorias_unidad_medida;
create table categorias_unidad_medida(
	codigo_cum char(1) not null,
	nombre varchar(100) not null,
	constraint categorias_unidad_medida_pk primary key (codigo_cum)
);

drop table if exists unidades_medida;
create table unidades_medida(
	codigo_udm char(2) not null,
	descripcion varchar(100) not null,
	categoria_udm char(1)not null,
	constraint unidades_medida_pk primary key (codigo_udm),
	constraint unidades_medida_fk foreign key (categoria_udm) 
	references categorias_unidad_medida(codigo_cum)
);



insert into categorias_unidad_medida(codigo_cum,nombre) 
values('U','Unidades');
insert into categorias_unidad_medida(codigo_cum,nombre) 
values('V','Volumen');
insert into categorias_unidad_medida(codigo_cum,nombre) 
values('P','Peso');
insert into categorias_unidad_medida(codigo_cum,nombre) 
values('L','Longitud');

insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('ml','militros','V');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('l','litros','V');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('u','unidad','U');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('d','docena','U');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('g','gramos','P');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('kg','kilogramos','P');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('lg','libras','P');

select * from unidades_medida;
select * from categorias_unidad_medida;

-----------------------------------------
drop table if exists producto;
create table producto(
	codigo_pro serial not null,
	nombre varchar(100) not null,
	unidad_medida_pro char(2)not null,
	precio_venta money not null,
	tiene_iva boolean not null,
	coste money not null,
	categoria_pro int not null,
	stock int not null,
	constraint producto_pk primary key (codigo_pro),
	constraint producto_udm_fk foreign key (unidad_medida_pro) 
	references unidades_medida(codigo_udm),
	constraint producto_categoria_fk foreign key (categoria_pro) 
	references categorias(codigo_cat)
);

insert into producto(nombre,unidad_medida_pro,precio_venta,tiene_iva,coste,categoria_pro,stock)
values('Coca Cola peque','u',0.5804,true,0.3729,7,100);
insert into producto(nombre,unidad_medida_pro,precio_venta,tiene_iva,coste,categoria_pro,stock)
values('Salsa  de tomatee','kg',0.95,true,0.8736,3,0);
insert into producto(nombre,unidad_medida_pro,precio_venta,tiene_iva,coste,categoria_pro,stock)
values('Mostaza','kg',0.95,true,0.89,3,0);
insert into producto(nombre,unidad_medida_pro,precio_venta,tiene_iva,coste,categoria_pro,stock)
values('Fuze Tea','u',0.8,true,0.7,7,50);


select * from producto;
----------------------------
drop table if exists tipo_documento;
create table tipo_documento(
	codigo_doc char(1) not null,
	descripcion varchar(100) not null,
	constraint tipo_documento_pk primary key (codigo_doc)
);

drop table if exists proveedores;
create table proveedores(
	identificador char(13) not null,
	tipo_documento_prov char(1) not null,
	nombre varchar(100) not null,
	telefono varchar(10) not null,
	correo varchar(100) not null,
	direccion varchar(100) not null,
	constraint proveedores_pk primary key (identificador),
	constraint proveedores_doc_fk foreign key (tipo_documento_prov) 
	references tipo_documento(codigo_doc)
);

insert into tipo_documento(codigo_doc,descripcion)values('C','Cedula');
insert into tipo_documento(codigo_doc,descripcion)values('R','Ruc');

insert into proveedores(identificador,tipo_documento_prov,nombre,telefono,correo,direccion)
values ('1756309967','C','Paola','0984739345','paolasfas@gmail.com','Cumbyakior');
insert into proveedores(identificador,tipo_documento_prov,nombre,telefono,correo,direccion)
values ('1724166440001','R','Snacks','0998950730','snacks@gmail.com','La tola');

select * from proveedores;

------------------------------------------------------
drop table if exists estado_pedido;
create table estado_pedido(
	codigo_estado char(1) not null,
	descripcion varchar(100) not null,
	constraint estado_pedido_pk primary key (codigo_estado)
);
drop table if exists cabecera_pedidos;
create table cabecera_pedidos(
	numero serial not null,
	proveedor_cp char(13) not null,
	fecha date not null,
	estado_pedido_cp char(1)not null,
	constraint cabecera_pedidos_pk primary key (numero),
	constraint cabecera_pedidos_prov_fk foreign key (proveedor_cp) 
	references proveedores(identificador),
	constraint cabecera_pedidos_est_fk foreign key (estado_pedido_cp) 
	references estado_pedido(codigo_estado)
);
insert into estado_pedido(codigo_estado,descripcion)
values ('S','Solicitado');
insert into estado_pedido(codigo_estado,descripcion)
values ('R','Recibido');

insert into cabecera_pedidos(proveedor_cp,fecha,estado_pedido_cp)
values ('1756309967','2023-11-30','R');
insert into cabecera_pedidos(proveedor_cp,fecha,estado_pedido_cp)
values ('1724166440001','2023-11-20','R');

select * from estado_pedido;
select * from cabecera_pedidos;

-------------------------------------------------
drop table if exists detalle_pedidos;
create table detalle_pedidos(
	codigo_dp serial not null,
	cabecera_pedido_dp int not null,
	producto_dp int not null,
	cantidad_solicitada int not null,
	subtotal money not null,
	cantidad_recibida int not null,
	constraint detalle_pedidos_pk primary key (codigo_dp),
	constraint detalle_pedidos_cabecera_pedido_fk foreign key (cabecera_pedido_dp) 
	references cabecera_pedidos(numero),
	constraint detalle_pedidos_pro_fk foreign key (producto_dp) 
	references producto(codigo_pro)
);

insert into detalle_pedidos(cabecera_pedido_dp,producto_dp,cantidad_solicitada,subtotal,cantidad_recibida)
values (1,1,100,37.29,100);
insert into detalle_pedidos(cabecera_pedido_dp,producto_dp,cantidad_solicitada,subtotal,cantidad_recibida)
values (1,4,50,11.8,50);
insert into detalle_pedidos(cabecera_pedido_dp,producto_dp,cantidad_solicitada,subtotal,cantidad_recibida)
values (2,1,10,3.73,10);
select * from detalle_pedidos;

-----------------------------------
drop table if exists historial_stock;
create table historial_stock(
	codigo_hs serial not null,
	fecha timestamp with time zone not null,
	referencia_dp_hs int not null,
	producto_hs int not null,
	cantidad int not null,
	constraint historial_stock_pk primary key (codigo_hs),
	constraint historial_stock_referencia_fk foreign key (referencia_dp_hs) 
	references detalle_pedidos(codigo_dp),
	constraint historial_stock_pro_fk foreign key (producto_hs) 
	references producto(codigo_pro)
);
insert into historial_stock(fecha,referencia_dp_hs,producto_hs,cantidad)
values ('2023-11-30 19:59',1,1,100);
insert into historial_stock(fecha,referencia_dp_hs,producto_hs,cantidad)
values ('2023-12-30 17:59',2,4,50);
insert into historial_stock(fecha,referencia_dp_hs,producto_hs,cantidad)
values ('2023-08-30 16:00',3,1,10);
select *from historial_stock;

---------------------------------------
drop table if exists cabecera_ventas;
create table cabecera_ventas(
	codigo_cv serial not null,
	fecha timestamp with time zone not null,
	total_sin_iva money not null,
	iva money not null,
	total money not null,
	constraint cabecera_ventas_pk primary key (codigo_cv)
);

drop table if exists detalle_ventas;
create table detalle_ventas(
	codigo_dv serial not null,
	cabecera_ventas_dv int not null,
	producto_dv int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
	con_iva money not null,
	constraint detalle_venta_pk primary key (codigo_dv),
	constraint detalle_venta_cv_fk foreign key (cabecera_ventas_dv) 
	references cabecera_ventas(codigo_cv),
	constraint detalle_venta_pro_fk foreign key (producto_dv) 
	references producto(codigo_pro)
);
insert into cabecera_ventas(fecha,total_sin_iva,iva,total)values('2023-11-30 19:59',3.26,0.39,3.65);

insert into detalle_ventas(cabecera_ventas_dv,producto_dv,cantidad,precio_venta,subtotal,con_iva)
values (1,1,5,0.58,2.9,3.25);
insert into detalle_ventas (cabecera_ventas_dv,producto_dv,cantidad,precio_venta,subtotal,con_iva)
values (1,4,1,0.36,0.36,0.4);



