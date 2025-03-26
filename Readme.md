# Host and Slice: Your File Mirroring Solution

Host and Slice provides a quick and easy way to set up a file mirroring service on the cloud.  It leverages Docker and Nginx to efficiently serve large files, even if you need to split them into smaller, downloadable chunks.

**Directory Structure:**
```
├── Readme.md
├── blob -> data_nginx/www/blob
├── data_nginx
│   ├── default.conf
│   └── www
│       ├── anya.jpeg
│       ├── blob
│       │   └── splitit.sh
│       └── index.html
└── docker-compose.yml
```


**How it Works:**

1.  **Place Files:**  Place the files you want to mirror in the `data_nginx/www/blob` directory (accessible via the `blob` symbolic link).
2.  **(Optional) Split:** If your files are large, use the `splitit.sh` script (located in `data_nginx/www/blob`) to split them into smaller, more manageable chunks.
3. **Start the service:** the files are avaliable for download via http.
4. **Serve Files:** Nginx will serve the files directly from the `blob` directory.
5. **(Optional) Merge Downloaded files:** 
  ```
  # 於Windows環境下，參考下列方式合併下載之檔案:
  cmd /c "copy /b small_part_* combined_file.bin"

  # 檢查MD5
  Get-FileHash combined_file.bin -Algorithm MD5
  ```

**Quick Start:**

1.  **Clone the repository:**

    ```bash
    git clone <your-repository-url>
    cd <repository-directory>
    ```

2.  **Start the service:**

    ```bash
    docker-compose up -d
    ```

    This will start the Nginx server in the background.

3. **Configure nginx proxy manager**

   a. Goto the admin page: http://[[yourserver]]:9487/ (e.g. http://localhost:9487/))
     - Default Administrator User
       - Email:    admin@example.com
       - Password: changeme
   
   b. Add a proxy host in Nginx Proxy Manager:
     1. Proxy Hosts -> Add Proxy Host
     2. 配置
       - Domain Names: 請依您情況配置，如 localhost or 該台機器的ip or domain name
       - scheme: http
       - Foward Host/IP: nginx
       - Forward Port: 80

   See https://nginxproxymanager.com/guide/ for more info.



4. **Access your files**
   place your blob files under blob dir.
   Files can be accessed via  http://<yourserver>/blob/<filename>



**Using `splitit.sh`:**

The `splitit.sh` script allows you to split large files into smaller parts, which can be useful for:

*   **Faster Downloads:** Smaller files download more quickly, especially on slower networks.
*   **Resumable Downloads:** If a download is interrupted, you only need to resume downloading the current chunk, not the entire file.
*   **Overcoming File Size Limits:** Some systems or services might have limits on the maximum size of a file that can be uploaded or downloaded.

**Example usage of `splitit.sh`**

1. **navigate to the blob folder:**
    ```bash
    cd data_nginx/www/blob
    ```
2. **make splitit.sh executable:**
    ```bash
    chmod +x splitit.sh
    ```

3. **split the file:**
    ```bash
    ./splitit.sh your_big_file.zip
    ```
    this will generate the split file in the same folder.
    after split, the orginal file can be removed.


**Configuration:**

* **Nginx:** The Nginx configuration is located in `data_nginx/default.conf`. You can modify this file to customize server settings, such as port, SSL, and more.
* **blob:** the file place in `data_nginx/www/blob` will be served.

