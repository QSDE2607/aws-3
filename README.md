# Tích hợp kho dữ liệu phim ảnh lên AWS Redshift

<h1> Tổng quan dự án </h1>

Netflix là dịch vụ xem video trực tuyến của rất nổi tiếng hiện nay, ở bài Assginment này bạn sẽ được thực hành xây dựng một On-premises Data Warehouse dùng để chứa thông tin về các bộ phim đang được chiếu trên Netflix. Sau đó, bạn sẽ thực hiện thao tác để di chuyển On-premises Data Warehouse đó sang Cloud Data Warehouse (Amazon Redshift). 

<ul>
<li>Import Dataset vào SQL Server.</li>
<li>Tạo SSIS để làm ETL tải dữ liệu từ Dataset vào Data Warehouse.</li>
<li>Chuyển ETL vừa tạo từ SSIS sang dạng T-SQL ETL.</li>
<li>Tạo một Redshift Cluster để làm Cloud Data Warehouse.</li>
<li>Sử dụng công cụ Amazon SCT để chuyển đổi Schema giữa SQL Server và Redshift.</li>
<li>Di chuyển dữ liệu của On-premises Data Warehouse sang Cloud Data Warehouse.</li>
<li>Kiểm tra ETL có hoạt động đúng trên Redshift không.</li>
<li>(Nâng cao) so sánh hiệu năng giữa On-premises Data Warehouse và Cloud Data Warehouse.</li>
</ul>

<h1> Tài nguyên </h1>

Bạn cần tải Dataset ở [link sau](https://drive.google.com/drive/folders/1qvFgXWDQE9iZW7bctwA3HJys6O89_qTR?usp=sharing), Dataset này sẽ gồm 2 file như sau:

netflix_titles.csv: Chứ thông tin về các bộ phim hiện có trên Netflix.
extra_data.csv: Một số dữ liệu mẫu, giúp bạn thực hiện yêu cầu số 7 trong đề bài.

<h1> Yêu cầu chi tiết </h1> 

1. Import Dataset vào SQL Server

Bạn cần tải Dataset chứa thông tin về các bộ phim trên Netflix, sau đó import dữ liệu đó vào bảng ASM3_Source.netflix_shows. Để hoàn thành được yêu cầu này, bạn có thể tham khảo link "Import dữ liệu từ file CSV vào SQL Server" ở phần Tài nguyên.

![image](https://github.com/QSDE2607/aws-3/assets/171625181/0c848ad2-3bd9-4c9c-b0ac-0864571a41db)


2. Tạo SSIS để làm ETL tải dữ liệu từ Data Source vào Data Warehouse

Tiếp theo, bạn cần xây dựng một Data Warehouse  từ các dữ liệu vừa Import. Bạn hãy tạo một SSIS để làm một ETL load dữ liệu từ ASM3_Source vào On-Premises Data Warehouse. Data Warehouse của bạn có thể sử dụng cấu trúc như sau:

![image](https://github.com/QSDE2607/aws-3/assets/171625181/2c2f73e0-650f-47aa-9a03-c87835820040)


Sau khi chạy ETL, dữ liệu trong Data Warehouse sẽ được import như sau:

![image](https://github.com/QSDE2607/aws-3/assets/171625181/f9442f5e-9c1a-4569-af3e-ebe3971fb733)


3. Chuyển ETL vừa tạo từ SSIS sang dạng T-SQL ETL

Ngoài cách sử dụng SSIS để tạo ETL thì bạn cũng có thể tạo các STORED PROCEDURE để load dữ liệu từ Source vào Data Warehouse. Ví dụ với một Procedure dùng để load dữ liệu vào một DIM Table như sau:

![image](https://github.com/QSDE2607/aws-3/assets/171625181/de276a3d-cc21-44fa-8121-26d3f405cbf2)


Procedure này sẽ INSERT các trường type không trùng nhau và chưa có trong bảng DIM_TYPE vào DIM Table. Bạn có thể xem thêm video "Load Employee Dim using Stored Proc" để hiểu hơn về cách làm này.

![image](https://github.com/QSDE2607/aws-3/assets/171625181/69bd3be9-2970-480f-982a-f464cfc13616)


Bạn sẽ cần tạo một ETL dưới dạng SQL PROCEDURE để load dữ liệu từ ASM3_Source vào On-Premises Data Warehouse.

4. Tạo một Redshift Cluster để làm Cloud Data Warehouse

Bạn cần tạo một Redshift Cluster để làm Cloud Data Warehouse, chú ý là bạn cần sử dụng bản "Free Trial" để không bị tính phí khi làm Assignment này. Để hoàn thành yêu cầu này, bạn có thể tham khảo cách tạo Redshift ở bài Lab 10 - Xây dựng Redshift Cluster.

![image](https://github.com/QSDE2607/aws-3/assets/171625181/dc550df0-ae95-49a1-b9f1-1a15a23c075c)


5. Sử dụng công cụ Amazon SCT để chuyển đổi Schema giữa SQL Server và Redshift

Để có thể di chuyển được dữ liệu và ETL từ On-Premises Data Warehouse vào Redshift, bạn sẽ cần chuyển đổi các Schema và Procedure ở SQL Server sang dạng tương ứng ở Redshift. Amazon SCT là một công cụ sẽ giúp bạn thực hiện các thao tác này. 

Sau khi tải và cài đặt SCT, bạn sẽ cần tạo một Project mới như sau:

![image](https://github.com/QSDE2607/aws-3/assets/171625181/f4390f80-33b8-4990-af6d-63dacaa33e74)


Sau đó, bạn sẽ cần tạo các kết nối tới cả Source và Target Database đã tạo. Sau khi SCT đã kết nối thành công đến hai Database, bạn sẽ được danh sách các Table và Procedure như sau:

![image](https://github.com/QSDE2607/aws-3/assets/171625181/35b6fa4e-2255-4309-9c5b-e9a0c2eb6d73)


Bạn hãy chọn các Table, Procedure cần chuyển đổi sang Redshift, sau đó nhấn vào "Convert Schema". Bạn sẽ thấy các Table tương ứng ở bên Redshift như sau:

![image](https://github.com/QSDE2607/aws-3/assets/171625181/d87e67f7-9907-4d98-b9c9-6f1b69f0bd25)


Cuối cùng, bạn cần nhấn vào "Apply to Database" để SCT cập nhật các sự thay đổi này lên Redshift. Bạn có thể tham khảo link "Hướng dẫn sử dụng SCT" để tìm hiểu thêm về thao tác này.

6. Di chuyển dữ liệu của On-premises Data Warehouse sang Cloud Data Warehouse

Sau khi dữ liệu đã được đưa từ Source vào On-Premises DW, bạn sẽ cần di chuyển các dữ liệu đó lên Redshift. Yêu cầu này sẽ gồm các bước như sau:

Bước 1: Export dữ liệu từ SQL Server dưới dạng file csv.
Bước 2: Upload các file csv đó lên S3 Bucket.
Bước 3: Sử dụng câu lệnh S3Copy để import dữ liệu từ S3 Bucket vào Redshift. Câu lệnh này sẽ có dạng như sau:
COPY table_name (col1, col2, col3, col4)
FROM 's3://<your-bucket-name>/load/file_name.csv'
credentials 'aws_access_key_id=<Your-Access-Key-ID>;aws_secret_access_key=<Your-Secret-Access-Key>'
CSV
IGNOREHEADER 1;
Sau khi Import dữ liệu vào Redshift xong, bạn có thể sử dụng Data Grip connect tới Redshift và kiểm tra xem dữ liệu đã thực sự được import hay chưa.

7. Kiểm tra ETL có hoạt động đúng trên Redshift không

Khi di chuyển từ  On-premises Data Warehouse sang Cloud Data Warehouse, bạn cũng sẽ cần đảm bảo các ETL đã viết có thể hoạt động tốt trên môi trường Cloud. Bạn hãy thực hiện các bước sau để kiểm tra ETL:

Bước 1: Tạo một Database mới trên Redshift để làm Database Source, hoặc bạn có thể sử dụng SCT để convert Schema cho ASM3_Source.netflix_shows lên Redshift.
Bước 2: Import dữ liệu từ file "extra_data.csv" vào Source trên Redshift.
Bước 3: Chạy lại Procedure ETL đã di chuyển lên Redshift.
Bước 4: Kiểm tra xem dữ liệu từ Source đã được load lên Data Warehouse trên Redshift hay chưa. Nếu chưa được load thì tức là bạn chưa migrate ETL thành công.
8. (Nâng cao) so sánh hiệu năng giữa On-premises Data Warehouse và Cloud Data Warehouse

Ở yêu cầu nâng cao, bạn sẽ cần thực hiện và ghi lại thời gian thực thi các ETL trong các trường hợp sau:

Chạy ETL sử dụng SSIS ở On-premises Data Warehouse.
Chạy ETL sử dụng T-SQL PROCEDURE ở On-premises Data Warehouse.
Chạy ETL sử dụng T-SQL PROCEDURE ở Cloud Data Warehouse.
