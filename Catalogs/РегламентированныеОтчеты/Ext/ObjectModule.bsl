﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс		
	
Процедура ГенерироватьНовыйКод() Экспорт

	// Код элемента имеет представление:
	//  ГГГЭЭЭ, где
	//    ГГГ - порядковый номер группы или элементов верхнего уровня;
	//    ЭЭЭ - порядковый номер элемента внутри группы.
	//
	// Порядковые номера определяются с лидирующими нулями.

	Если ЭтоГруппа ИЛИ Уровень() = 0 Тогда
		
		Если ЭтоНовый() Тогда
			УстановитьНовыйКод();
		КонецЕсли;
		ТекКод      = Код;
		КодГруппы   = Число(Лев(ТекКод, 3)) + 1;
		Код         = Формат(КодГруппы, "ЧЦ=3; ЧВН=;") + "000";
		
	Иначе
		
		// для элемента справочника второго уровня
		ТекКод      = Код;
		КодГруппы   = Лев(Родитель.Код, 3);
		УстановитьНовыйКод(КодГруппы);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийМодуляОбъекта

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Не ЭтоНовый() Тогда

		ПрежнийРодитель = Ссылка.Родитель;

		Если ПрежнийРодитель <> Родитель Тогда

			// В случае, когда объект сменил родителя (переместили элемент
			// из одной группы в другую), для обеспечения настроенного порядка
			// следования элементов переопределяем код объекта в соответствии
			// с порядком следования элементов текущего уровня иерархии.
			//
			// Принимаем следующие правила:
			// при перемещении объекта из одной группы в другую
			// размещаем его в конец списка вложенных в группу элементов.
			//
			// В соответствии спинятыми правилами формируем новый код объекта:

			СписокКодов    = Новый СписокЗначений;

			РегламОтчеты   = Справочники.РегламентированныеОтчеты;
			ВыборкаОтчеты  = РегламОтчеты.Выбрать(Родитель, Владелец, , "Код Возр");

			Пока ВыборкаОтчеты.Следующий() Цикл
				СписокКодов.Добавить(ВыборкаОтчеты.Код);
			КонецЦикла;

			Если СписокКодов.Количество() = 0  Тогда
				// На данном уровне не имеется элементов справочника.
				// Объекту присваиваем самый первый код.
				НовыйКодГруппы   = "001";
				НовыйКодЭлемента = "001";
			Иначе
				// Перемещенному объекту присваиваем очередной код согласно порядку следования.
				ПредКод          = СписокКодов.Получить(СписокКодов.Количество() - 1).Значение;
				НовыйКодГруппы   = Формат(Число(Лев( ПредКод, 3)) + 1, "ЧЦ=3; ЧВН=;");
				НовыйКодЭлемента = Формат(Число(Прав(ПредКод, 3)) + 1, "ЧЦ=3; ЧВН=;");
			КонецЕсли;

			Если Уровень() > 0 Тогда
				// В случае, когда объект был перемещен в группу.
				НовыйКодГруппы   = Лев(Родитель.Код, 3);
			Иначе
				// В случае, когда объект был перемещен на верхний
				// уровень иерархии (не имеет родителя).
				НовыйКодЭлемента = "000";
			КонецЕсли;

			// В соответствии с принятыми обозначениями код объекта формируется из порядкового
			// кода группы и порядкового кода элемента внутри группы.
			Код = НовыйКодГруппы + НовыйКодЭлемента;

		КонецЕсли;
		
	Иначе
		
		ГенерироватьНовыйКод();

	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли