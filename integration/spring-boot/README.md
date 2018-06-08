# Spring Boot

ATSD [storage driver](https://github.com/axibase/spring-boot) for Spring Boot simplifies the process of instrumenting Spring Boot applications.

## Settings

| Name | Required | Default Value | Description |
| --- | --- | --- | --- |
|  `metrics.export.url`  |  No  |  `http://localhost:8088/api/v1/command`  |  ATSD API URL  |
|  `metrics.export.username`  |  Yes  |  –  |  ATSD Username.  |
|  `metrics.export.password`  |  Yes  |  –  |  ATSD Password.  |
|  `metrics.export.bufferSize`  |  No  |  `64`  |  Size of metrics buffer. Metrics writer flushes the buffer if it is full or by schedule (configured by `spring.metrics.export.*` properties.)  |
|  `metrics.names.entity`  |  No  |  `atsd-default`  |  Entity name.  |
|  `metrics.names.metricPrefix`  |  No  |  –  |  A prefix to be added to the original metric name.  |
|  `metrics.names.tags.*`  |  No  |  –  |  Optional set of key-value pairs in the ATSD time series identifier.  |

## Configuration

Configuration settings are specified in the `application.properties` file.

`application.properties` file example:

```txt
metrics.export.username: admin
metrics.export.password: secret
metrics.export.url: http://atsd_hostname:8088/api/v1/command
metrics.export.bufferSize: 16
metrics.names.entity: spring-boot-sample
metrics.names.metricPrefix: spring-boot
metrics.names.tags.ip: 127.0.0.1
metrics.names.tags.organization: Axibase
```

## Metrics

Refer to [AtsdNamingStrategy and AtsdMetricWriter](https://github.com/axibase/spring-boot/blob/master/spring-boot-samples/spring-boot-sample-metrics-atsd/src/main/java/sample/metrics/atsd/SampleAtsdExportApplication.java) example.

Enable public metrics export:

```java
@Bean
    public MetricsEndpointMetricReader metricsEndpointMetricReader(MetricsEndpoint metricsEndpoint) {
        return new MetricsEndpointMetricReader(metricsEndpoint);
    }

        @Bean
    @ExportMetricWriter
    @ConfigurationProperties("metrics.export")
    public MetricWriter atsdMetricWriter() {
        AtsdMetricWriter writer = new AtsdMetricWriter();
        writer.setNamingStrategy(namingStrategy());
        return writer;
    }

    @Bean
    @ConfigurationProperties("metrics.names")
    public AtsdNamingStrategy namingStrategy() {
        return new DefaultAtsdNamingStrategy();
    }
```

### Wrapping Methods using Custom Metrics

Wrap all class methods.

```java
@Measured
public class JdbcCityRepository implements CityRepository
```

Wrap a specific method.

```java

@Measured
 public List<City> findCities()
```
