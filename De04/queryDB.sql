-- Câu 2:
create or alter procedure procCau2
	@MaKH varchar(10),
	@Nam int,
	@SoLuongHD int output
as begin
	select @SoLuongHD = count(*)
	from HoaDonTT hd
	join PhieuDat pd on pd.MaBooking = hd.MaBooking
	where pd.MaKH = @MaKH
end
go

declare @SoLuongHD int
exec procCau2 'KH001', 2025, @SoLuongHD output
select 'KH001' as MaKH, 2025 as Nam, @SoLuongHD as SoLuongHD
go


-- Câu 3
create function funcCau3 (@MaLP varchar(10))
returns table
as return (
	select lp.MaLP, lp.KieuPhong, lp.DienTich, lp.DonGiaPhong, p.MaPhong
	from LoaiPhong lp
	join Phong p on p.MaLP = lp.MaLP
	where lp.MaLP = @MaLP
)
go

select * from funcCau3('LP001')
go


-- Câu 4
alter table PhieuDat
add SLPhongDat int default 0 with values
go

create or alter trigger triggerCau4 
on ChiTietPhongDat
for insert, update, delete
as begin
	set nocount on

	update pd
	set pd.SLPhongDat = isnull(sum(ct.SLPhong), 0)
	from PhieuDat pd
	join ChiTietPhongDat ct on ct.MaBooking = pd.MaBooking
	where pd.MaBooking in (
		select MaBooking from inserted
		union
		select MaBooking from deleted
	)
end
go


-- Câu 5
create or alter view viewCau5
as
	select nv.MaNV, nv.TenNV, 
		hd.MaHDTT, hd.NgayLapHD, hd.NgayTT, hd.PhuongThucTT, hd.MaBooking, 
		pd.NgayDenDuKien, pd.NgayDiDuKien
	from NhanVien nv
	join HoaDonTT hd on hd.MaNV = nv.MaNV
	join PhieuDat pd on pd.MaBooking = hd.MaBooking
	where pd.NgayDenDuKien between '2022-12-12' and '2022-12-19'
go

select * from viewCau5
go


-- Câu 6
create login NguyenDucThuan with password = '123'
create user NguyenDucThuan for login NguyenDucThuan

grant select, insert, update on PhieuDat to NguyenDucThuan with grant option
go

create login NguyenTienTai with password = '123'
create user NguyenTienTai for login NguyenTienTai

-- === Đăng nhập user NguyenDucThuan === --
use QLKhachSan_Vu_231220962
go

grant select, update on PhieuDat to NguyenTienTai
go
-- === Thoát user NguyenDucThuan === --

-- Câu 7
create procedure procCau7
	@NamBatDau int,
	@NamKetThuc int
as begin
	select top 3 year(hd.NgayTT) as Nam, month(hd.NgayTT) as Thang, sum(lp.DonGiaPhong * ct.SLPhong) as DoanhThuThang
	from HoaDonTT hd
	join ChiTietPhongDat ct on ct.MaBooking = hd.MaBooking
	join LoaiPhong lp on lp.MaLP = ct.MaLP
	where year(hd.NgayTT) between @NamBatDau and @NamKetThuc
	group by month(hd.NgayTT), year(hd.NgayTT)
	order by DoanhThuThang desc
end
go

exec procCau7 2000, 2027
go
