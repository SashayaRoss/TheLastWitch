//
//  PlayerCharacterMapper.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 09/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

final class PlayerCharacterMapper: PlayerCharacterMapping {
    func map(entity: PlayerModel) -> PlayerCharacterStatsModel {
      //jeśli gracz ma nierozdysponowane punkty, przyciski do ich rozdania wyświetlają się
        let isAddButtonActive = entity.levelPoints != 0

       //Tworzę listę zadań, które wyświetlą się w części questy
        let activeQuestList = entity.quests.map {
            if $0.isFinished == false {
            //jeśli jest aktywny wyświetl jego opis
            //jeśli nie jest aktywny wyświetl przed opisem przedrostek [FINISHED], aby gracz wiedział, że wykonał zadanie i może wrócić do NPC po nagrodę
                return $0.isActive == true ? $0.desc : ($0.desc + " [FINISHED]")
            } else {
                //jeśli status quest’u wskazuje na jego zakończenie zwróć nil’a
                return nil
            }
        //zwróć w tablicy tylko obiekty niepuste, takie które nie są nil’ami
        }.compactMap({
            $0
        //połącz wszystkie elementy w jeden String za pomocą separatora
        }).joined(separator: "\n- ")
        
        return PlayerCharacterStatsModel(
            //zamieniam wszystkie wartości liczbowe na String
            level: String(entity.level),
            levelPoints: String(entity.levelPoints),
            currentExp: String(entity.expPoints),
            maxExp: String(entity.maxExpPoints),
            health: String(entity.maxHpPoints),
            magic: String(Int(entity.maxMagic * 100)),
            speed: String(Int(entity.maxSpeed * 100)),
            questList: activeQuestList,
            isAddButtonActive: isAddButtonActive
        )
    }
}
