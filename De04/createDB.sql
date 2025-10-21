create database QLKhachSan_Vu_231220962
go

use QLKhachSan_Vu_231220962
go

create table KhachHang (
	MaKH		varchar(10)		not null,
	TenKH		nvarchar(50)	not null,
	DiaChi		nvarchar(300)	not null,
	DienThoai	varchar(20)		not null,
	CCCD		varchar(20)		not null,
	GioiTinh	varchar(10)	    not null,
	NgaySinh	date			not null,

	primary key(MaKH)
)


create table NhanVien (
	MaNV		varchar(10)		not null,
	TenNV		nvarchar(50)	not null,
	SoCCCD		varchar(20)		not null,
	SDT			varchar(20)		not null,
	NgaySinh	date			not null,
	GioiTinh	varchar(10)		not null,
	ChucVu		nvarchar(20)	not null,

	primary key(MaNV)
)


create table PhieuDat (
	MaBooking			varchar(10)		not null,
	TienDatCoc			money			not null,
	NgayDenDuKien		datetime		not null,
	NgayDiDuKien		datetime		not null,
	PhuongThucDatCoc	nvarchar(20)	not null,
	MaKH				varchar(10)		not null,

	primary key (MaBooking),
	foreign key (MaKH) references KhachHang(MaKH)
)


create table HoaDonTT (
	MaHDTT			varchar(10)		not null,
	MaBooking		varchar(10)		not null,
	NgayTT			datetime		not null,
	NgayLapHD		datetime		not null,
	PhuongThucTT	nvarchar(50)	not null,
	MaNV			varchar(10)		not null,
	GhiChu			nvarchar(300)	null,

	primary key(MaHDTT),
	foreign key(MaBooking) references PhieuDat(MaBooking),
	foreign key(MaNV) references NhanVien(MaNV)
)


create table LoaiPhong (
	MaLP		varchar(10)		not null,
	KieuPhong	nvarchar(30)	not null,
	DienTich	float			not null,
	DonGiaPhong	money			not null,

	primary key (MaLP)
)


create table Phong (
	MaPhong		varchar(10)		not null,
	MaLP		varchar(10)		not null,
	TinhTrang	nvarchar(30)	not null,

	primary key (MaPhong),
	foreign key (MaLP) references LoaiPhong(MaLP)
)


create table PhieuThue (
	MaPT				varchar(10)		not null,
	MaBooking			varchar(10)		not null,
	ThoiGianLap			datetime		not null,
	ThoiGianCheckout	datetime		not null,
	ThoiGianCheckin		datetime		not null,
	KMPhong				float			null,
	MaPhong				varchar(10)		not null,

	primary key (MaPT),
	foreign key (MaBooking)	references PhieuDat(MaBooking),
	foreign key (MaPhong) references Phong(MaPhong)
)


create table ChiTietPhongDat (
	MaBooking	varchar(10)	not null,
	MaLP		varchar(10)	not null,
	SLPhong		int			not null,

	primary key (MaBooking, MaLP),
	foreign key (MaBooking)	references PhieuDat(MaBooking),
	foreign key (MaLP) references LoaiPhong(MaLP)
)
go


-- 1. Khách hàng
insert into KhachHang (MaKH, TenKH, DiaChi, DienThoai, CCCD, GioiTinh, NgaySinh)
values ('KH001', N'Nguyễn Văn A', N'123 Đường A, Quận 1, TP.HCM', '0909123456', '123456789', 'Nam', '1990-01-15');

insert into KhachHang (MaKH, TenKH, DiaChi, DienThoai, CCCD, GioiTinh, NgaySinh)
values ('KH002', N'Trần Thị B', N'456 Đường B, Quận 3, TP.HCM', '0909988776', '987654321', 'Nữ', '1992-05-20');

-- 2. Nhân viên
insert into NhanVien (MaNV, TenNV, SoCCCD, SDT, NgaySinh, GioiTinh, ChucVu)
values
('NV001', N'Lê Văn C', '123456789', '0911222333', '1988-08-12', 'Nam', N'Lễ tân'),
('NV002', N'Phạm Thị D', '987654321', '0988776655', '1991-03-10', 'Nu', N'Quản lý');

-- 3. Loại phòng
insert into LoaiPhong (MaLP, KieuPhong, DienTich, DonGiaPhong)
values
('LP001', N'Phòng đơn', 20.5, 500000),
('LP002', N'Phòng đôi', 35.0, 800000);

-- 4. Phòng
insert into Phong (MaPhong, MaLP, TinhTrang)
values
('P001', 'LP001', N'Trống'),
('P002', 'LP001', N'Đang thuê'),
('P003', 'LP002', N'Trống');

-- 5. Phiếu đặt
insert into PhieuDat (MaBooking, TienDatCoc, NgayDenDuKien, NgayDiDuKien, PhuongThucDatCoc, MaKH)
values
('B001', 200000, '2025-10-25', '2025-10-28', N'Tiền mặt', 'KH001'),
('B002', 300000, '2025-10-26', '2025-10-27', N'Chuyển khoản', 'KH002');

-- 6.Phieu thue
insert into PhieuThue (MaPT, MaBooking, ThoiGianLap, ThoiGianCheckout, ThoiGianCheckin, KMPhong, MaPhong)
values
('PT001', 'B001', '2025-10-20 10:00', '2025-10-28 12:00', '2025-10-25 14:00', 0, 'P001'),
('PT002', 'B002', '2025-10-21 11:00', '2025-10-27 12:00', '2025-10-26 14:00', 10, 'P002');

-- 7. Hóa đơn thanh toán
insert into HoaDonTT (MaHDTT, MaBooking, NgayTT, NgayLapHD, PhuongThucTT, MaNV, GhiChu)
values
('HD001', 'B001', '2025-10-25 15:00', '2025-10-20 10:00', N'Tiền mặt', 'NV001', N'Thanh toán đủ'),
('HD002', 'B002', '2025-10-26 16:00', '2025-10-21 11:00', N'Chuyển khoản', 'NV002', N'Thanh toán một phần');

-- 8. Chi tiết phòng đặt
insert into ChiTietPhongDat (MaBooking, MaLP, SLPhong)
values
('B001', 'LP001', 1),
('B002', 'LP002', 1);
