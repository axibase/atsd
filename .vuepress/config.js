module.exports = {
    title: 'ATSD Documentation (DRAFT)',
    themeConfig: {
        sidebar: [
            {
                title: 'API',
                children: [
                    ['/api/data/', 'Data API'],
                    ['/api/meta/', 'Meta API'],
                ]
            }
        ],
        searchMaxSuggestions: 10,
    }
}