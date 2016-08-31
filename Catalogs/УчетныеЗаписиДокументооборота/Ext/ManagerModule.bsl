﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ОбработкаПолученияФормы("Справочник", "УчетныеЗаписиДокументооборота", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик обновления БРО 1.0.1.24
//
Процедура ЗаполнениеРеквизитовУчетныхЗаписейПриОбновлении() Экспорт
	Выборка = Справочники.УчетныеЗаписиДокументооборота.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектУЗ = Выборка.ПолучитьОбъект();
		Если ЗначениеЗаполнено(ОбъектУЗ.АдресЭлектроннойПочты) Тогда
			Если НЕ (ЗначениеЗаполнено(ОбъектУЗ.СпецоператорСвязи) ИЛИ ОбъектУЗ.ОбменНапрямую) Тогда
				Если СтрНайти(НРег(ОбъектУЗ.АдресЭлектроннойПочты), "taxcom.ru")>0 Тогда
					ОбъектУЗ.СпецоператорСвязи = Перечисления.СпецоператорыСвязи.Такском;
				Иначе
					ОбъектУЗ.СпецоператорСвязи = Перечисления.СпецоператорыСвязи.Прочие;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ОбъектУЗ.СтатусУчетнойЗаписи = Перечисления.СтатусыУчетнойЗаписиДокументооборота.Активна;
		ОбъектУЗ.ОбменДанными.Загрузка = Истина;
		ОбъектУЗ.Записать();
	КонецЦикла;
КонецПроцедуры

// Обработчик обновления БРО 1.0.5.1
//
Процедура ЗадатьДляУчетныхЗаписейИспользованиеСервисаОнлайнПроверки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиДокументооборота.Ссылка КАК УчетнаяЗаписьСсылка
		|ИЗ
		|	Справочник.УчетныеЗаписиДокументооборота КАК УчетныеЗаписиДокументооборота
		|ГДЕ
		|	УчетныеЗаписиДокументооборота.СпецоператорСвязи = ЗНАЧЕНИЕ(Перечисление.СпецоператорыСвязи.КалугаАстрал)
		|	ИЛИ УчетныеЗаписиДокументооборота.СпецоператорСвязи = ЗНАЧЕНИЕ(Перечисление.СпецоператорыСвязи.Форус)";
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		УчетнаяЗаписьОбъект = Выборка.УчетнаяЗаписьСсылка.ПолучитьОбъект();
		УчетнаяЗаписьОбъект.ИспользоватьСервисОнлайнПроверкиОтчетов = Истина;
		
		УчетнаяЗаписьОбъект.ОбменДанными.Загрузка = Истина;
		
		УчетнаяЗаписьОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли