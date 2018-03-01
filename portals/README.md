# Portals

Portal is a collection of time-series [widgets](https://axibase.com/products/axibase-time-series-database/visualization/widgets/) created using the [Axibase Charts](https://github.com/axibase/charts#axibase-charts) and presented in a [grid](portal-settings.md#layout) layout.

The Axibase Charts library provides a simple yet powerful syntax, closely integrated with the ATSD [data model](https://axibase.com/products/axibase-time-series-database/data-model/), so that even a user with no programming experience can build and deploy real-time dashboards with minimal effort.

Syntax Examples:

* [70 lines](https://apps.axibase.com/chartlab/3230deb6/8/)
* [200 lines](https://apps.axibase.com/chartlab/2ef08f32)

The power user, on the other hand, can leverage [inheritance](https://axibase.com/products/axibase-time-series-database/visualization/widgets/inheritance), [wildcards](https://axibase.com/products/axibase-time-series-database/visualization/widgets/wildcards/), [control structures](https://axibase.com/products/axibase-time-series-database/visualization/widgets/control-structures), [computed series](https://axibase.com/products/axibase-time-series-database/visualization/widgets/computed-metrics), [display filters](https://axibase.com/products/axibase-time-series-database/visualization/widgets/display-filters), and other [advanced features](https://axibase.com/products/axibase-time-series-database/visualization/) to create data-driven applications such as [data sliders](http://apps.axibase.com/slider/energinet-2017/?slide=1), [cross-filters](http://apps.axibase.com/cross-filter/?table=Linux%20Performance), [statistic viewers](https://apps.axibase.com/chartlab/cde99874/2/#fullscreen) etc.

## Custom Portals

Custom portals can be created as described in the following [guide](portals-overview.md#create-portal).

## Built-in Portals

ATSD contains built-in portals which are listed on the [Portals](portals-overview.md#portals-page) page.
                                                                   
- ATSD (self monitoring)
- Linux nmon
- AIX nmon
- Amazon Web Services EC2
- Amazon Web Services EBS
- Google cAdvisor
- Docker Host, Container
- Microsoft SCOM
- ITM Operating System
- ActiveMQ Broker
- SolarWinds
- tcollector
- scollector
- collectd
- VMware
- JVM
- nginx Web Server

The built-in portals can be customized by changing their configuration text and used as a foundation when developing custom portals.

## Built-in Portal Gallery

|  |  |  |
| --- | --- | --- |
| HP OpenView ![](resources/ovpm_portal_linux-705x560.png) | Oracle Host ![](resources/oracle_host_portal-705x541.png) | Oracle Databases ![](resources/oracle_databases_poral3-705x596.png) |
| cAdvisor Host ![](resources/cadvisor_host_portal3-705x559.png) | cAdvisor Disk Detail ![](resources/cadvisor_disk_detail_portal2-705x562.png) | cAdvisor Overview ![](resources/cadvisor_overview_portal-705x505.png) | 
| SCOM SQL Server ![](resources/scom_sql_server_portal-705x451.png) | ATSD Host ![](resources/fresh_atsd_portal21-705x435.png) | SolarWinds Base ![](resources/solarwinds_base_portal_31-705x487.png) | 
| tcollector ![](resources/tcollector-portal1-705x472.png) | VMware Host ![](resources/vmware_host_portal-705x473.png) | VMware Host VM Breakdown ![](resources/vmware_hostvm_breakdown_portal-705x473.png) |
| VMware Cluster ![](resources/vmware_cluster_portal-705x475.png) | Vmware VM ![](resources/vmware_vm_portal-705x476.png) | SCOM Server ![](resources/scom_server_portal-705x452.png)
| nmon AIX ![](resources/nmon-aix-portal-1000-705x360.png) |
