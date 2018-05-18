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
            { text: "API Clients", link: '/api/' },
        ]
    },
    { text: 'SQL', link: '/sql/' },
    { text: 'Rule Engine', link: '/rule-engine/' },
    { text: 'Integration', link: '/integration/' }
]


const restApiMenu = [
    // ['', 'Overview'], // Waiting for New overview page
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
]

const ruleEngineMenu = [
    ['','Overview'],
    ['window.md','Windows'],
    ['grouping.md','Grouping'],
    ['condition.md','Condition'],
    ['filters.md','Filters'],
    ['functions.md','Functions'],
    ['placeholders.md','Placeholders'],
    ['overrides.md','Overrides'],
    ['web-notifications.md','Web Notifications'],
    ['email.md','Email Notifications'],
    ['commands.md','System Commands'],
    ['derived.md','Derived Commands'],
    ['logging.md','Logging'],
]

module.exports = {
    title: 'ATSD Documentation (DRAFT)',
    themeConfig: {
        nav: topNavMenu,
        
        sidebarDepth: 1,
        sidebar: {
            '/api/data/': restApiMenu,
            '/api/meta/': restApiMenu,
            '/rule-engine/': ruleEngineMenu,
            '/sql/': [
                ''
            ]
        },

        searchMaxSuggestions: 10,

        ...githubSettings
    }
}

