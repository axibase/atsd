# Compaction Test

## Overview

Perform this compaction test to calculate ATSD storage efficiency and estimate disk space requirements for a custom dataset. 

## Instructions

* Open **Admin > Diagnostics > Compaction** page.
* Initiate the compaction task. Refresh the page until the task is completed.
* Open **Admin > Database Tables** page. Take note of the `d` table size in the **Store File Size (MB)** column of the Summary table.
* Insert the dataset. Make sure that the amount of data is 50+ megabytes (CSV file size) or 1+ million samples.
* Execute the compaction again on **Compaction** page.
* Reload the **Database Tables** page and calculate the difference in the **Store File Size (MB)** value.
* Multiply the difference by 1048576 and divide it by the total number of samples in the dataset to calculate bytes/sample ratio.

The ratio represents an estimated amount of disk space required to store one 'time:value' sample for the current [file system compression codec](compaction.md#file-system-compression).