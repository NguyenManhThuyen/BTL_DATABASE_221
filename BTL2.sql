CREATE DATABASE BTL5

use BTL5;

------------------------------------
--CREATE ENTITY

--DROP TABLE KhachHang
CREATE TABLE KhachHang (
  Ma_KH int NOT NULL IDENTITY(1, 1), -- tăng bước nhảy lên 1 & bắt đầu từ 1
  SDT varchar(10) NOT NULL,
  Ho_Va_Ten varchar(45) NOT NULL,
  DIACHI varchar(96) NOT NULL,
  PRIMARY KEY (Ma_KH),
  CONSTRAINT SDT_UNIQUE UNIQUE(SDT) -- ko có SĐT nào lặp lại
);


-- DROP TABLE DonHang
CREATE TABLE DonHang (
  Ma_DH int NOT NULL IDENTITY(1, 1),
  Ma_KH int NOT NULL,
  Nguoi_Tao_Don varchar(45) NOT NULL,
  Ngay_Tao_Don time default GETDATE(),
  Note varchar(200),
  PRIMARY KEY (Ma_DH),
  CONSTRAINT fk_Ma_KH1 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH)
);

--DROP TABLE HangHoa

CREATE TABLE HangHoa (
	Ma_HH varchar(10) NOT NULL UNIQUE,
	Ten varchar(20) NOT NULL,
	Mo_Ta_Chi_Tiet varchar(200),
	Link_Anh_sp varchar(200),
	Nha_Cung_Cap varchar(20) NOT NULL,
	So_Luong_Ton_Kho int default 10,
	Mau_Sac varchar(10),
	Qui_Cach varchar(200),
	Loai_Hang varchar(10),
	Gia int NOT NULL,
	PRIMARY KEY (Ma_HH)
);

-- drop table NhomKH
CREATE TABLE NhomKH (
	Ma_Nhom int NOT NULL UNIQUE,
	Ten_Nhom varchar(20) NOT NULL,
	So_No int default 0,
	Ma_KH int NOT NULL UNIQUE,
	PRIMARY KEY (Ma_Nhom),
	CONSTRAINT fk_Ma_Nhom_KH1 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH)
);

CREATE TABLE PhieuThuChi (
	Ma_Phieu int NOT NULL,
	PRIMARY KEY(Ma_Phieu),
	Loai varchar(10) NOT NULL CHECK (Loai IN('Thu', 'Chi')),
	Tien int NOT NULL,
	Ngay TIME default GETDATE(),
	Ma_KH int NOT NULL UNIQUE,
	CONSTRAINT fk_Ma_KH2 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH),
	NOTE varchar(200)
);

CREATE TABLE HoaDon (
	Ma_HD int NOT NULL,
	PRIMARY KEY (Ma_HD),
	Ma_KH int NOT NULL,
	Ma_DH int NOT NULL,
	Don_Gia int NOT NULL,
	VAT int NOT NULL default 8,
	Ngay TIME default GETDATE(),
	Trang_Thai varchar(40) NOT NULL CHECK (Trang_Thai IN('Cho', 'Dang_Xu_Ly','Hoan_Thanh','Huy'))
	CONSTRAINT fk_Ma_KH3 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH),
	CONSTRAINT fk_Ma_DH1 FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH)
);

CREATE TABLE TienTrinh (
	PID int NOT NULL UNIQUE,
	PRIMARY KEY (PID),
	Ngay TIME NOT NULL,
	Ma_HD int NOT NULL,
	CONSTRAINT fk_Ma_HD1 FOREIGN KEY (Ma_HD) REFERENCES HoaDon(Ma_HD),
	Trang_Thai varchar(40) NOT NULL CHECK (Trang_Thai IN('Cho', 'Dang_Xu_Ly','Hoan_Thanh','Huy'))
);

CREATE TABLE NhanVien (
	EID int NOT NULL UNIQUE,
	Ho_Va_Ten varchar(45) NOT NULL,
	Vai_Tro varchar(40) NOT NULL CHECK (Vai_Tro
	IN('QLGH', 'TX','XK','QL','NVLD','KT','TN','NVBH')),
	PRIMARY KEY(EID)
);

CREATE TABLE ChuyenHang (
	Ma_Chuyen int NOT NULL UNIQUE,
	PRIMARY KEY (Ma_Chuyen)
);

CREATE TABLE TinhTrangChuyen (
	Ma_Chuyen int,
	[Date] TIME NOT NULL DEFAULT GETDATE(),
	Trang_Thai varchar(40) NOT NULL CHECK (Trang_Thai IN('Cho_Khoi_Hanh', 'Da_Khoi_Hanh','Da_Hoan_Thanh')),
	CONSTRAINT fk_Ma_Chuyen1 FOREIGN KEY (Ma_Chuyen) REFERENCES ChuyenHang(Ma_Chuyen),
	PRIMARY KEY (Ma_Chuyen)
);

CREATE TABLE DonViVanChuyen (
	Ma_VC int NOT NULL unique,
	Phuong_Tien varchar(40) NOT NULL CHECK (Phuong_Tien IN('Xe_may', 'Oto')),
	Loai varchar(40) NOT NULL CHECK (Loai IN('Insource', 'Outsource')),
	PRIMARY KEY (Ma_VC)
);

CREATE TABLE VanChuyenNgoai (
	Ma_VC int NOT NULL UNIQUE,
	IDM int NOT NULL UNIQUE,
	IDD int NOT NULL UNIQUE,
	Ten varchar(40),
	PRIMARY KEY (Ma_VC),
	CONSTRAINT fk_Ma_VC1 FOREIGN KEY (Ma_VC) REFERENCES DonViVanChuyen(Ma_VC)
);

CREATE TABLE VanChuyenCty (
	Ma_VC int NOT NULL UNIQUE,
	IDM int NOT NULL UNIQUE,
	IDD int NOT NULL UNIQUE,
	PRIMARY KEY (Ma_VC),
	CONSTRAINT fk_Ma_VC2 FOREIGN KEY (Ma_VC) REFERENCES DonViVanChuyen(Ma_VC),
	CONSTRAINT fk_IDM2 FOREIGN KEY (IDM) REFERENCES NhanVien(EID),
	CONSTRAINT fk_IDD2 FOREIGN KEY (IDD) REFERENCES NhanVien(EID)
);

------------------------------------------------------------
--CREATE RELATION 

CREATE TABLE ThuocNhom (
	Ma_Nhom int NOT NULL UNIQUE,
	Ma_KH int NOT NULL UNIQUE,
	Ten_Nhom varchar(20) NOT NULL,
	PRIMARY KEY (Ma_Nhom),
	CONSTRAINT fk_Ma_KH4 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH),
	CONSTRAINT fk_Ma_Nhom FOREIGN KEY (Ma_Nhom) REFERENCES NhomKH(Ma_Nhom)
	--CONSTRAINT fk_Ten_Nhom FOREIGN KEY (Ten_Nhom) REFERENCES NhomKH(Ten_Nhom)
);

CREATE TABLE ThuChi (
	Ma_Phieu int NOT NULL,
	EID int NOT NULL,
	PRIMARY KEY (Ma_Phieu),
	CONSTRAINT fk_EID1 FOREIGN KEY (EID) REFERENCES NhanVien(EID),
	CONSTRAINT fk_Ma_Phieu FOREIGN KEY (Ma_Phieu) REFERENCES PhieuThuChi(Ma_Phieu)
);

CREATE TABLE NhanVienTao (
	EID int NOT NULL,
	Ma_DH int NOT NULL,
	PRIMARY KEY (Ma_DH),
	CONSTRAINT fk_EID2 FOREIGN KEY (EID) REFERENCES NhanVien(EID),
	CONSTRAINT fk_Ma_DH FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH)
);

CREATE TABLE XuatBan (
	EID int NOT NULL,
	Ma_DH int NOT NULL,
	PRIMARY KEY (Ma_DH),
	CONSTRAINT fk_EID3 FOREIGN KEY (EID) REFERENCES NhanVien(EID),
	CONSTRAINT fk_Ma_DH2 FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH)
);

CREATE TABLE KHTao (
	Ma_DH int NOT NULL,
	PRIMARY KEY(Ma_DH),
	Ma_KH int NOT NULL UNIQUE,
	CONSTRAINT fk_Ma_KH5 FOREIGN KEY (Ma_KH) REFERENCES KhachHang(Ma_KH),
	CONSTRAINT fk_Ma_DH3 FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH)
);

CREATE TABLE BaoGom (
	Ma_DH int NOT NULL,
	Ma_HH varchar(10),
	PRIMARY KEY (Ma_DH,Ma_HH),
	CONSTRAINT fk_Ma_DH4 FOREIGN KEY (Ma_DH) REFERENCES DonHang(Ma_DH),
	CONSTRAINT fk_Ma_HH1 FOREIGN KEY (Ma_HH) REFERENCES HangHoa(Ma_HH)
);

CREATE TABLE XuLy (
	PID int NOT NULL UNIQUE,
	PRIMARY KEY (PID),
	Ma_HD int NOT NULL,
	CONSTRAINT fk_Ma_HD2 FOREIGN KEY (Ma_HD) REFERENCES HoaDon(Ma_HD),
	CONSTRAINT fk_PID1 FOREIGN KEY (PID) REFERENCES TienTrinh(PID)
);

CREATE TABLE VanChuyen (
	Ma_VC int NOT NULL unique,
	Ma_Chuyen int NOT NULL UNIQUE,
	PRIMARY KEY(Ma_VC),
	CONSTRAINT fk_Ma_Chuyen5 FOREIGN KEY (Ma_Chuyen) REFERENCES ChuyenHang(Ma_Chuyen),
	CONSTRAINT fk_Ma_VC3 FOREIGN KEY (Ma_VC) REFERENCES DonViVanChuyen(Ma_VC)
);

CREATE TABLE GomKienHang (
	Ma_Chuyen int NOT NULL UNIQUE,
	Ma_HD int NOT NULL,
	Ma_HH varchar(10),
	Can_Nang int NOT NULL,
	Noi_Den varchar(20) NOT NULL,
	So_Luong int NOT NULL,
	CONSTRAINT fk_Ma_HD3 FOREIGN KEY (Ma_HD) REFERENCES HoaDon(Ma_HD),
	CONSTRAINT fk_Ma_Chuyen6 FOREIGN KEY (Ma_Chuyen) REFERENCES ChuyenHang(Ma_Chuyen),
	CONSTRAINT fk_Ma_HH2 FOREIGN KEY (Ma_HH) REFERENCES HangHoa(Ma_HH),
	PRIMARY KEY (Ma_Chuyen,Ma_HD,Ma_HH)
);

--------------------------------------------

--INSERT TABLE KHachHang
SELECT * FROM KhachHang
DELETE KhachHang
INSERT INTO KhachHang VALUES (0849434447,'Nguyen Manh Thuyen','28 Lac Long Quan, TT Quang Phu, Huyen Cumgar, Tinh Daklak');
INSERT INTO KhachHang VALUES (0986941029,'Nguyen Van A','12 Phan Van Tri, Quan Go Vap, TP HCM');
INSERT INTO KhachHang VALUES (0947284932,'Nguyen Thi B','108 Mai Chi Tho, Quan Binh Thanh, TP HCM');
INSERT INTO KhachHang VALUES (0926185736,'Nguyen Van C','54 Tran Xuan Soan, Quan 7, TP HCM');
INSERT INTO KhachHang VALUES (0992837465,'Nguyen Van D','277 Nam Ky Khoi Nghia, Quan 3, TP HCM');

-- INSERT TABLE DonHang
SELECT * FROM DonHang
INSERT INTO DonHang VALUES (5,'Nguyen Van D',GETDATE(),'Hang de vo');
INSERT INTO DonHang VALUES (5,'Nguyen Van D',GETDATE(),'Giao hang nhanh giup em a :<');
INSERT INTO DonHang VALUES (5,'Nguyen Van D',GETDATE(),'Shop dong goi ky giup em');
INSERT INTO DonHang VALUES (3,'Nguyen Thi B',GETDATE(),NULL);
INSERT INTO DonHang VALUES (2,'Nguyen Van A',GETDATE(),'Shop check hang ky giup em nha');

SELECT * FROM DonHang inner join KhachHang on DonHang.Ma_KH = KhachHang.Ma_KH

--INSERT TABLE HangHoa

-------------------------------------------------
--2.1 Thu Tuc INSERT UPDATE DROP dbo.KhachHang
go
CREATE PROCEDURE checkNMT ( @Ma_KH INT,
							@SDT VARCHAR(10),
						    @Ho_Va_Ten  VARCHAR(45),
					        @DIACHI  VARCHAR(96),
					        @StatementType NVARCHAR(20) = '')
AS
  BEGIN
      IF @StatementType = 'Insert'
        BEGIN
            INSERT INTO KhachHang   (Ma_KH,SDT,Ho_Va_Ten,DIACHI)
            VALUES     (@Ma_KH,@SDT,@Ho_Va_Ten,@DIACHI)
        END

      IF @StatementType = 'Select'
        BEGIN
            SELECT *
            FROM   KhachHang
        END

      IF @StatementType = 'Update'
        BEGIN
            UPDATE KhachHang
            SET    SDT = @SDT,
                   Ho_Va_Ten = @Ho_Va_Ten,
                   DIACHI=@DIACHI
            WHERE  Ma_KH=@Ma_KH
        END
      ELSE IF @StatementType = 'Delete'
        BEGIN
            DELETE FROM KhachHang
            WHERE  Ma_KH = @Ma_KH
        END
  END
  GO
  -------------------------------------

--
CREATE PROCEDURE Loc_KH_Co_Tren_0_DH_GiamDan
AS
SELECT Ho_Va_Ten,SDT,count(*) as 'So don da dat' FROM DonHang as  d inner join KhachHang as k on d.Ma_KH = k.Ma_KH
GROUP BY k.Ho_Va_Ten,SDT
having count(*) > 0
order by count(*) DESC

EXEC Loc_KH_Co_Tren_0_DH_GiamDan
