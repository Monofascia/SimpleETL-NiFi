# SimpleETL-NiFi
This study aims to show the potentiality of the new Apache Iceberg implemented by Dremio. 

:warning: Keep in mind I'm not a developer but a Data Scientist / Engineer :warning:  
This study is made only to verify the potentiality of Iceberg. It's neither optimazed nor fully automated.  

STEP TO FOLLOW to replicate the process:
1. Follow this course: [Apache Iceberg](https://university.dremio.com/course/apache-iceberg).
   - I installed Docker on my wsl but can be done also on windows.
   - My IDE is VSCode with Docker widget installed.
2. Generate another image with [NiFi 1.26](https://hub.docker.com/r/apache/nifi/tags) **tag=1.26**
   - create a foldere in your root, for example mine is here \\wsl.localhost\Ubuntu\home\piezzi\data
   - run on your shell:  
     > docker run -itd --name NiFi_ETL2 -e NIFI_WEB_HTTP_PORT='8080' -p 8080:8080 -v /data:/data apache/nifi:1.26.0

3. Launch NiFi
4. Go to [mockaroo](https://mockaroo.com/) and save your schema:
   - Mine is like in this picture (JSON format, 1000 rows, not check null record)  
![mockaroo_image](/mockaroo_schema.png?raw=true)  
   - By going into page 'Schemas', scroll down to 'Generating data via cURL' an save the link after curl "..."
5. Upload into NiFi the **NiFi_Flow.json**
6. ![NiFi_screenshot](/NiFi_screenshot.jpg)
7. Open the group
   - Open the first processor InvokeHTTP and change the link saved in point 4.
8. Right-click in empty space and "Enable all controller services"
9. Run **only** the first processor InvokeHTTP and wait at least 200 seconds
   - On the sticky note it's explained the download limit for a free account on mockaroo, it's 200 requests per day  
10.After reaching >=200 Task/time, stop first processor and run MergeRecord  
11. Run UpdateAttribute
12. Run PutFile
13. Go to your path, mine is \\wsl.localhost\Ubuntu\home\piezzi\data and verify if there's a file called mockaroo0.json  

<ins>If it's your first run, skip this part and go to step 17</ins>

14. On your local machine open **concatenation.py**
15. Change the path in the variable wdir with yours
16. Run the script
17. Open in browser Dremio (http://localhost:9047/)
18. Upload your dataset just created *mockaroo0.json*
19. Go to SQL runner section and paste the content of the file dremio_history.sql
    - Keep an eye on line 16. Since I have a date column, I partitioned it based on YEAR(). Partition is based on this column. If yours is different, please adapt the script.   
20. Select context _nessi-main_
21. Run lines from 11 to 28
22. Run SELECT * .. (line 31)
23. Run SELECT * .. (line 32)
24. Go to Jobs section and open in a new panel the first two results (runs at points 22 and 21)
25. Analyze them 

A greater difference in execution time can be seen with greater table.  
Repeat the process from step 8 day-by-day to increase numerosity of records. Each time the process is repeated, delete table from dremio and nessi. 

