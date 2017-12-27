import { environment } from '../../../../environments/environment';
import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Resolve, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs/Observable';
import { HttpClient, HttpParams } from '@angular/common/http';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { Subject } from 'rxjs/Subject';
import 'rxjs/add/operator/map';

import { WebSocketService } from '../../../core/services/web-socket.service';

@Injectable()
export class LightService {
    card: any;
    messages: Subject<any>;

    // Our constructor calls our wsService connect method
    constructor(private http: HttpClient, private wsService: WebSocketService) {
        this.messages = <Subject<any>>wsService
            .connect()
            .map((response: any): any => {
                return response;
            });
    }

    // Our simplified interface for sending
    // messages back to our socket.io server
    sendMsg(msg) {
        this.messages.next(msg);
    }

    getCard(cardId?: number, typeId?: number, relatives?: number): Observable<any> {
        let params = new HttpParams();

        if (cardId) {
            params = params.append('cardId', cardId.toString());
        }
        if (typeId) {
            params = params.append('typeId', typeId.toString());
        }
        if (relatives) {
            params = params.append('relatives', relatives.toString());
        }

        return this.http.get(environment.apiUrl + 'api/cards', { params: params });

    }

    getCardParent(cardId?: number, relatives?: number): Observable<any> {
        let params = new HttpParams();

        if (cardId) {
            params = params.append('cardId', cardId.toString());
        }
        if (relatives) {
            params = params.append('relatives', relatives.toString());
        }

        return this.http.get(environment.apiUrl + 'api/cards/' + cardId + '/parent', { params: params });

    }

    getCardChildren(cardId: number): Observable<any> {
        let params = new HttpParams();

        return this.http.get(environment.apiUrl + 'api/cards/' + cardId + '/children', { params: params });

    }

    createCard(card: any): Observable<any> {
        return this.http.post(environment.apiUrl + 'api/cards', card);
    }

    updateCard(id: number, card: any): Observable<any> {
        return this.http.patch(environment.apiUrl + 'api/cards/' + id, card);
    }
}
