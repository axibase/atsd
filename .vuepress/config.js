const githubSettings = {
    docsRepo: 'axibase/atsd',
    editLinks: true,
    editLinkText: 'Help us improve this page!'
}

const topNavMenu = [
    {
        text: 'API',
        items: [
            { text: "Rest API", link: '/api/data/' },
            { text: "Network API", link: '/api/network/' },
            { text: "API Clients", link: '/api/clients/' },
        ]
    },
    { text: 'SQL', link: '/sql/' },
    { text: 'Rule Engine', link: '/rule-engine/' },
    { text: 'Integration', link: '/integration/' }
]

const integrationMenu = [
    {
        title: 'Collectors', children: [
            ['https://github.com/axibase/axibase-collector', 'Axibase Collector'],
            'collectd/',
            'graphite/',
            'java-metrics/',
            'nmon/',
            'scollector/',
            'statsd/',
            'tcollector/',
        ]
    },

    {
        title: 'Reporting Tools', children: [
            'aer/',
            'alteryx/',
            'chartlab/',
            'matlab/',
            'odbc/',
            'pentaho/',
            'spss/modeler/',
            'spss/statistics/',
            'stata/',
            'tableau/',
        ]
    },

    ['https://github.com/axibase/atsd-use-cases', 'Examples'],
];


const restApiMenu = [
    ['', 'Overview'], // Waiting for New overview page
    {
        title: 'Series', children: [
            `/api/data/series/insert`,
            `/api/data/series/query`,
            `/api/data/series/csv-insert`,
            `/api/data/series/url-query`,
            `/api/data/series/delete`,
        ]
    },
    {
        title: 'Properties', children: [
            `/api/data/properties/insert`,
            `/api/data/properties/query`,
            `/api/data/properties/url-query`,
            `/api/data/properties/type-query`,
            `/api/data/properties/delete`,
        ]
    },
    {
        title: 'Messages', children: [
            `/api/data/messages/insert`,
            `/api/data/messages/webhook`,
            `/api/data/messages/query`,
            `/api/data/messages/delete`,
            `/api/data/messages/stats-query`,
        ]
    },
    {
        title: 'Alerts', children: [
            `/api/data/alerts/query`,
            `/api/data/alerts/update`,
            `/api/data/alerts/delete`,
            `/api/data/alerts/history-query`,
        ]
    },
    {
        title: 'Metric', children: [
            `/api/meta/metric/get`,
            `/api/meta/metric/list`,
            `/api/meta/metric/update`,
            `/api/meta/metric/create-or-replace`,
            `/api/meta/metric/delete`,
            `/api/meta/metric/series`,
            `/api/meta/metric/series-tags`,
        ]
    },
    {
        title: 'Entity', children: [
            `/api/meta/entity/get`,
            `/api/meta/entity/list`,
            `/api/meta/entity/update`,
            `/api/meta/entity/create-or-replace`,
            `/api/meta/entity/delete`,
            `/api/meta/entity/entity-groups`,
            `/api/meta/entity/metrics`,
            `/api/meta/entity/property-types`,
        ]
    },
    {
        title: 'Entity Group', children: [
            `/api/meta/entity-group/get`,
            `/api/meta/entity-group/list`,
            `/api/meta/entity-group/update`,
            `/api/meta/entity-group/create-or-replace`,
            `/api/meta/entity-group/delete`,
            `/api/meta/entity-group/add-entities`,
            `/api/meta/entity-group/set-entities`,
            `/api/meta/entity-group/delete-entities`,
        ]
    },
    {
        title: 'Extended', children: [
            `/api/data/ext/command`,
            `/api/data/ext/csv-upload`,
            `/api/data/ext/nmon-upload`,
            `/api/meta/misc/search`,
            `/api/meta/misc/ping`,
            `/api/meta/misc/version`,
        ]
    },
];

const networkApiMenu = [
    ['', 'Overview'],
    { title:"Data Commands", children: [
        ['series.md', 'series'],
        ['property.md', 'property'],
        ['message.md', 'message'],
        ['csv.md', 'csv'],
        ['nmon.md', 'nmon'],
        ['tcollector.md', 'tcollector'],
        ['graphite.md', 'Graphite'],
        ['statsd.md', 'StatsD'],
    ]},
    { title:"Meta Commands", children: [
        ['entity.md', 'entity'],
        ['metric.md', 'metric'],
    ]},
    { title:"Control Commands", children: [
        ['ping.md', 'ping'],
        ['time.md', 'time'],
        ['version.md', 'version'],
        ['exit.md', 'exit'],
    ]},
]

const ruleEngineMenu = [
    ['', 'Overview'],
    ['window.md', 'Windows'],
    ['grouping.md', 'Grouping'],
    ['filters.md', 'Filters'],
    ['condition.md', 'Condition'],
    ['operators.md', 'Operators'],
    ['window-fields.md', 'Fields'],
    ['variables.md', 'Variables'],
    ['functions.md', 'Functions'],
    ['placeholders.md', 'Placeholders'],
    ['control-flow.md', 'Control Flow'],
    ['overrides.md', 'Overrides'],
    ['email.md', 'Email'],
    ['incoming-webhooks.md', 'Incoming Webhooks'],
    ['notifications/', 'Outgoing Webhooks'],
    ['commands.md', 'System Commands'],
    ['derived.md', 'Derived Commands'],
    ['logging.md', 'Logging'],
];

const ruleNotificationsMenu = [
    ['', 'Overview'],    
    ['slack.md', 'Slack'],
    ['telegram.md', 'Telegram'],
    ['discord.md', 'Discord'],
    ['hipchat.md', 'HipChat'],
    ['aws-api.md', 'AWS API'],
    ['aws-sns.md', 'Amazon SNS'],
    ['aws-sqs.md', 'Amazon SQS'],
    ['azure-sb.md', 'Azure Service Bus'],
    ['gcp-ps.md', 'Google Cloud Pub/Sub'],
    ['webhook.md', 'Webhook'],
    'custom.md',
];

module.exports = {
    title: 'ATSD Documentation (DRAFT)',
    themeConfig: {
        nav: topNavMenu,

        sidebarDepth: 1,
        sidebar: {
            '/api/data/': restApiMenu,
            '/api/meta/': restApiMenu,
            '/api/network/': networkApiMenu,
            '/rule-engine/notifications/': ruleNotificationsMenu,
            '/rule-engine/': ruleEngineMenu,
            '/integration/': integrationMenu,
            '/sql/': [
                '',
                ['scheduled-sql.md', 'Scheduled Queries'],
                ['scheduled-sql-store.md', 'Materialized Views'],
                ['permissions.md', 'Permissions'],
                ['performance.md', 'Query Optimization'],
                ['api.md', 'API Endpoint'],
                ['https://github.com/axibase/atsd-jdbc#jdbc-driver', 'JDBC Driver'],
                ['client/', 'Bash Client'],
            ],
            '/': []
        },

        searchMaxSuggestions: 10,

        ...githubSettings
    }
}

