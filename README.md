# SimpleETL-NiFi
This study aims to show the potentiality of the new Apache Iceberg implemented by Dremio environment. 

:warning: Keep in mind I'm not a developer but a Data Scientist / Engineer :warning:  
This study is made only to verify the potentiality of Iceberg. It's neither optimazed nor fully automated.  

STEP TO FOLLOW to replicate the process:
1. Follow this course: [Apache Iceberg](https://university.dremio.com/course/apache-iceberg).
   - I installed Docker on my wsl but can be done also on windows.
   - My IDE is VSCode with Docker widget installed.
3. Generate another image with [NiFi 1.26](https://hub.docker.com/r/apache/nifi/tags) **tag=1.26**
   - create a foldere in your root, for example mine is here \\wsl.localhost\Ubuntu\home\piezzi\data
   - run on your shell:  
     > docker run -itd --name NiFi_ETL2 -e NIFI_WEB_HTTP_PORT='8080' -p 8080:8080 -v /data:/data apache/nifi:1.26.0

 
4. Launch NiFi
5. Go to [mockaroo](https://mockaroo.com/) and save your schema:
   - Mine is like in this picture (JSON format, 1000 rows, not check null record)  
![mockaroo_image](/mockaroo_schema.png?raw=true)  
   - By going into page 'Schemas', scroll down to 'Generating data via cURL' an save the link after curl "..."
7. Upload into NiFi the **NiFi_Flow.json**
8. ![NiFi_screenshot](/NiFi_screenshot.jpg)
9. Open the group
   - Open the first processor InvokeHTTP and change the link saved in point 4.
10. Right-click in empty space and "Enable all controller services"
11. Run **only** the first processor InvokeHTTP and wait at least 200 seconds
   - On the sticky note it's explained the download limit for a free account on mockaroo, it's 200 requests per day
11. After reaching >=200 Task/time, stop first processor and run MergeRecord
12. Run UpdateAttribute
13. Run PutFile
14. Go to your path, mine is \\wsl.localhost\Ubuntu\home\piezzi\data and verify if there's a file called mockaroo0.json  

<ins>If it's your first run, skip this part and go to step 16</ins>

13. On your local machine open **concatenation.py**
14. Change the path in the variable wdir with yours
15. Run the script
16. Open in browser Dremio (http://localhost:9047/)
17. Upload your dataset just created *mockaroo0.json*
18. Go to SQL runner section and paste the content of the file dremio_history.sql
    - Keep an eye on line 16. Since I have a date column, I partitioned it based on YEAR(). Partition is based on this column. If yours is different, please adapt the script.   
20. Select context _nessi-main_
21. Run lines from 11 to 28
22. Run SELECT * .. (line 31)
23. Run SELECT * .. (line 32)
24. Go to Jobs section and open in a new panel the first two results (runs at points 22 and 21)
25. Analyze them 


