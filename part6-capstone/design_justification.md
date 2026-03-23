## Storage Systems

To meet the hospital's four diverse goals, a multi-model polyglot persistence strategy was selected. For **Goal 1 (Readmission Risk)** and **Goal 3 (Monthly Reporting)**, a centralized **Data Warehouse (OLAP)** using a Star Schema is utilized. This structured environment is ideal for running complex analytical queries across historical patient data and financial records to identify trends in bed occupancy and costs without impacting the live hospital databases.

For **Goal 2 (Plain English Queries)**, I integrated a **Vector Database** (such as Pinecone or Milvus). Clinical notes and patient histories are largely unstructured text. By converting these notes into high-dimensional vector embeddings, the system enables semantic search. This allows doctors to find "cardiac events" even if the specific keyword isn't present, as the vector space recognizes the relationship between "heart attack," "myocardial infarction," and "chest pain."

Finally, for **Goal 4 (Real-time ICU Vitals)**, a **Data Lake** (implemented via DuckDB or S3) coupled with a streaming ingestor like Apache Kafka is used. High-frequency vitals generate massive write volumes that would overwhelm a traditional SQL database. The Data Lake allows us to store this "raw" telemetry data at scale for both real-time monitoring and long-term research.

## OLTP vs OLAP Boundary

The boundary in this architecture is defined by the **Extraction, Transformation, and Loading (ETL) process**. The **OLTP (Online Transactional Processing)** system consists of the primary hospital databases where nurses and doctors record live patient admissions, prescriptions, and billing. This system is optimized for fast, atomic updates and data integrity.

The transition to the **OLAP (Online Analytical Processing)** system occurs once data is moved into the Data Warehouse and Data Lake. We use a "Change Data Capture" (CDC) mechanism to move data from the live hospital SQL database to the analytical Star Schema. This ensures that the heavy, "expensive" queries used by management for monthly reports or by AI models for readmission predictions are run on a separate analytical copy of the data, thereby preventing any lag or downtime in the critical systems used for patient care.

## Trade-offs

A significant trade-off in this design is **Data Consistency vs. System Performance**, specifically regarding the real-time ICU vitals. By choosing a Data Lake (Eventual Consistency) over a strictly ACID-compliant RDBMS (Strong Consistency) for vitals, we risk a slight delay (milliseconds) between the device reading and the data being available for deep historical analysis. 

To mitigate this, I have implemented a **Lambda Architecture**. The "Speed Layer" processes the vitals immediately for real-time ICU alerts (ensuring patient safety), while the "Batch Layer" asynchronously writes the data to the Data Lake for long-term storage and reporting. This ensures that critical medical alerts are never delayed by the overhead of a massive analytical storage system.