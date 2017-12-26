import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';

import { SharedModule } from '../../../core/modules/shared.module';

import { LightComponent } from './light.component';

const routes = [
    {
        path: 'light',
        component: LightComponent
    }
];

@NgModule({
    declarations: [
        LightComponent
    ],
    imports: [
        SharedModule,
        RouterModule.forChild(routes)
    ],
    exports: [
        LightComponent
    ]
})

export class LightModule {
}
