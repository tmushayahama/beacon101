import { Component, OnInit } from '@angular/core';
import { FuseTranslationLoaderService } from '../../../core/services/translation-loader.service';
import { LightService } from './light.service';
import { locale as english } from './i18n/en';
import { locale as turkish } from './i18n/tr';

@Component({
    selector: 'fuse-light',
    templateUrl: './light.component.html',
    styleUrls: ['./light.component.scss']
})
export class LightComponent implements OnInit {
    public color = '#4785F5';

    constructor(private translationLoader: FuseTranslationLoaderService,
        private light: LightService) {
        this.translationLoader.loadTranslations(english, turkish);
    }

    ngOnInit() {
        this.light.messages.subscribe(msg => {
            console.log(msg);
            this.color = msg.text;
        });
    }


    sendMessage(msg) {
        console.log(msg);
        this.light.sendMsg(msg);
    }
}
