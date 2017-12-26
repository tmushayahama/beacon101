export class NavigationModel {
    public model: any[];

    constructor() {
        this.model = [
            {
                'id': 'applications',
                'title': 'Applications',
                'type': 'group',
                'children': [
                    {
                        'id': 'light',
                        'title': 'Light',
                        'type': 'item',
                        'icon': 'email',
                        'url': '/light',
                        'badge': {
                            'title': 25,
                            'bg': '#F44336',
                            'fg': '#FFFFFF'
                        }
                    }
                ]
            }
        ];
    }
}
