﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("Владелец");
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

Процедура ИсправитьНарушенияЕстественногоКлюча() Экспорт
	
	// Исправляет нарушения в данных справочника: наличие одинаковых элементов с одинаковым естественным ключем.
	// Такие нарушения могли получиться в результате того, что значения полей естественного ключа разных поколений данных 
	// отличались только регистром букв или концевыми пробелами.
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоляФормСтатистики.Владелец КАК Владелец,
	|	ПоляФормСтатистики.Код КАК Код,
	|	МАКСИМУМ(ПоляФормСтатистики.Ссылка) КАК КлючОшибки
	|ПОМЕСТИТЬ Ошибки
	|ИЗ
	|	Справочник.ПоляФормСтатистики КАК ПоляФормСтатистики
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоляФормСтатистики.Владелец,
	|	ПоляФормСтатистики.Код
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПоляФормСтатистики.Ссылка) > 1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Владелец,
	|	Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Ошибки.КлючОшибки КАК КлючОшибки,
	|	ПоляФормСтатистики.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПоляФормСтатистики КАК ПоляФормСтатистики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Ошибки КАК Ошибки
	|		ПО ПоляФормСтатистики.Владелец = Ошибки.Владелец
	|			И ПоляФормСтатистики.Код = Ошибки.Код
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПоляФормСтатистики.ПометкаУдаления,
	|	ПоляФормСтатистики.ЭтоГруппа
	|ИТОГИ ПО
	|	КлючОшибки";
	
	Ошибки = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Ошибки.Следующий() Цикл
		
		Дубли = Ошибки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ЭтоПервый = Истина;
		
		Пока Дубли.Следующий() Цикл
			
			Если ЭтоПервый Тогда
				// Первый элемент оставляем (он - скорее элемент, а не группа и скорее не помечен на удаление), остальные модифицируем.
				ЭтоПервый = Ложь;
				Продолжить;
			КонецЕсли;
			
			Объект = Дубли.Ссылка.ПолучитьОбъект();
			Объект.Код             = Строка(Новый УникальныйИдентификатор) + Объект.Код;
			Объект.ПометкаУдаления = Истина;
			Справочники.СтатистическиеПоказатели.ЗаписатьПоставляемыеДанные(Объект);
			
		КонецЦикла;
			
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
