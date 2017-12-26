import { Component, OnInit} from '@angular/core';
import { FuseTranslationLoaderService } from '../../../core/services/translation-loader.service';
import { LightService } from './light.service';
import { locale as english } from './i18n/en';
import { locale as turkish } from './i18n/tr';

@Component({
    selector: 'fuse-light',
    templateUrl: './light.component.html',
    styleUrls: ['./light.component.scss']
})
export class LightComponent {
    constructor(private translationLoader: FuseTranslationLoaderService) {
        this.translationLoader.loadTranslations(english, turkish);
    }

    ngOnInit() {
        this.chat.messages.subscribe(msg => {
            console.log(msg);
        });
    }

    sendMessage() {
        this.chat.sendMsg('Test Message');
    }
}
