﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область СлужебныеПроцедурыИФункции

Функция СоздатьПатентПоУмолчанию(Организация, Дата = Неопределено) Экспорт
	Перем ПатентПоУмолчанию;
	
	ПатентыОрганизации	= ПолучитьПатентыОрганизации(Организация, Дата);
	Если ПатентыОрганизации.Количество() > 0 Тогда
		ПатентПоУмолчанию	= ПатентыОрганизации[0];
	Иначе
		
		НовыйЭлемент	= СоздатьЭлемент();
		НовыйЭлемент.Владелец		= Организация;
		НовыйЭлемент.ДатаНачала		= НачалоГода(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
		НовыйЭлемент.ДатаОкончания	= КонецГода(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
		НовыйЭлемент.Наименование	= СтрШаблон(НСтр("ru = 'Деятельность на патенте %1'"), Формат(Год(НовыйЭлемент.ДатаНачала), "ЧГ=0"));
		НовыйЭлемент.ПостановкаНаУчетВНалоговомОргане	= Перечисления.ПостановкаНаУчетВНалоговомОргане.ПоМестуНахожденияОрганизации;
		
		Попытка
			НовыйЭлемент.Записать();
			ПатентПоУмолчанию	= НовыйЭлемент.Ссылка;
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Если ИнформацияОбОшибке.Причина = Неопределено Тогда
				ОписаниеОшибки = ИнформацияОбОшибке.Описание;
			Иначе
				ОписаниеОшибки = ИнформацияОбОшибке.Причина.Описание;
			КонецЕсли;
			ОписаниеОшибки = НСтр("ru = 'Ошибка при записи патента:'") + Символы.ПС + ОписаниеОшибки;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ПатентПоУмолчанию;
	
КонецФункции

Функция ПолучитьПатентыОрганизации(Организация, Дата = Неопределено) Экспорт
	
	МассивПатентов = Новый Массив;
	
	Запрос = Новый Запрос;
	
	Если Дата = Неопределено Тогда
		
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Патенты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Патенты КАК Патенты
			|ГДЕ
			|	Патенты.Владелец = &Владелец
			|	И НЕ Патенты.ПометкаУдаления";
		
	Иначе
		
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Патенты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Патенты КАК Патенты
			|ГДЕ
			|	Патенты.ДатаНачала <= &КонецДняДокумента
			|	И Патенты.ДатаОкончания >= &НачалоДняДокумента
			|	И Патенты.Владелец = &Владелец
			|	И НЕ Патенты.ПометкаУдаления";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Владелец", Организация);
	Если Дата <> Неопределено Тогда
		Запрос.УстановитьПараметр("НачалоДняДокумента", НачалоДня(Дата));
		Запрос.УстановитьПараметр("КонецДняДокумента", КонецДня(Дата));
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		МассивПатентов = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Возврат МассивПатентов;
	
КонецФункции

Функция ПолучитьПараметрыФормыВыбораДляКода(НазваниеМакета, ТекущийПериод) Экспорт
	
	КодыЛьгот = Новый ТаблицаЗначений;
	
	КодыЛьгот.Колонки.Добавить("Код");
	КодыЛьгот.Колонки.Добавить("Наименование");
	КодыЛьгот.Колонки.Добавить("КодЕдиницыИзмерения");
	
	Макет	= ПолучитьМакет(НазваниеМакета);
	
	НазваниеОбласти = "";
	СписокОбластей = Новый СписокЗначений;
	ОпределитьПараметрыСпискаКодов(Макет, ТекущийПериод, НазваниеОбласти, СписокОбластей);
	
	ТекущаяОбласть = Макет.Области.Найти("Область" + НазваниеОбласти);
	
	Если НЕ (ТекущаяОбласть = Неопределено) Тогда	
		
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			// Перебираем строки макета.
			КодПоказателя       = СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название            = СокрП(Макет.Область(НомерСтр, 2).Текст);
			КодЕдиницыИзмерения = СокрП(Макет.Область(НомерСтр, 3).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				НоваяСтрока = КодыЛьгот.Добавить();
				НоваяСтрока.Код                 = КодПоказателя;
				НоваяСтрока.Наименование        = Название;
				НоваяСтрока.КодЕдиницыИзмерения = КодЕдиницыИзмерения;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("СписокКодов"           , КодыЛьгот);
	Параметры.Вставить("СписокПериодовДействия", СписокОбластей);
	Параметры.Вставить("ТекущийПериод"         , НазваниеОбласти);
	
	Возврат Параметры;
	
КонецФункции

Процедура ОпределитьПараметрыСпискаКодов(Макет, ТекущийПериод, НазваниеОбласти, СписокОбластей)
	
	Области = Макет.Области;
	Если Области.Количество() = 0 Тогда
		НазваниеОбласти = "";
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекОбласть Из Области Цикл
		СписокОбластей.Добавить(Прав(ТекОбласть.Имя,4));
	КонецЦикла;
	
	ТекущаяОбласть = СписокОбластей[0].Значение;
	Для Каждого ТекОбласть Из СписокОбластей Цикл
		Если Год(ТекущийПериод) < Число(ТекОбласть.Значение) Тогда
			Прервать;
		КонецЕсли;
		
		ТекущаяОбласть = ТекОбласть.Значение;
	КонецЦикла;
	
	НазваниеОбласти = ТекущаяОбласть;
	
КонецПроцедуры

#Область ОплатаПатентаИзСпискаЗадач

Функция ДанныеУплатаПатента(Патент, Срок) Экспорт
	
	ДанныеПатента = Новый Структура("КБК, КодНалоговогоОргана, ОКАТО, Сумма, Описание");
	
	ПорядокПлатежей = ПорядокПлатежей();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Патенты.КБК,
	|	ВЫБОР
	|		КОГДА Патенты.ДатаВторогоПлатежа = &СрокПлатежа
	|			ТОГДА Патенты.СуммаВторогоПлатежа
	|		ИНАЧЕ Патенты.СуммаПервогоПлатежа
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА Патенты.ПостановкаНаУчетВНалоговомОргане = ЗНАЧЕНИЕ(Перечисление.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане)
	|			ТОГДА Патенты.НалоговыйОрган.Код
	|		ИНАЧЕ Патенты.Владелец.РегистрацияВНалоговомОргане.Код
	|	КОНЕЦ КАК КодНалоговогоОргана,
	|	ВЫБОР
	|		КОГДА Патенты.ПостановкаНаУчетВНалоговомОргане = ЗНАЧЕНИЕ(Перечисление.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане)
	|			ТОГДА Патенты.КодПоОКТМО
	|		ИНАЧЕ Патенты.Владелец.РегистрацияВНалоговомОргане.КодПоОКТМО
	|	КОНЕЦ КАК ОКАТО,
	|	Патенты.НомерПатента,
	|	Патенты.ДатаНачала,
	|	Патенты.ДатаОкончания,
	|	Патенты.Владелец КАК Организация,
	|	ВЫБОР
	|		КОГДА Патенты.ДатаВторогоПлатежа = &СрокПлатежа
	|			ТОГДА 2
	|		КОГДА Патенты.ДатаПервогоПлатежа = Патенты.ДатаОкончания
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ПорядокПлатежа
	|ИЗ
	|	Справочник.Патенты КАК Патенты
	|ГДЕ
	|	Патенты.Ссылка = &Патент";
	
	Запрос.УстановитьПараметр("Патент", Патент);
	Запрос.УстановитьПараметр("СрокПлатежа", Срок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеПатента, Выборка);
		
		ШаблонОписания = ". Оплата %1стоимости патента N %2 от %3";
		Описание = СтрШаблон(ШаблонОписания, ПорядокПлатежей[Выборка.ПорядокПлатежа], Выборка.НомерПатента, Формат(Выборка.ДатаНачала, "ДЛФ=D"));
		ДанныеПатента.Вставить("Описание", Описание);
	КонецЕсли;
	
	Возврат ДанныеПатента;
	
КонецФункции

// Формирует список действующих правил по организации в периоде
Функция ПравилаУплатыПатентов(Организация, ТекущаяДата) Экспорт
	
	ТаблицаПравил = НовыйТаблицаПравил();
	
	ПорядокПлатежей = ПорядокПлатежей();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Патенты.Ссылка,
	|	Патенты.ДатаПервогоПлатежа,
	|	Патенты.ДатаВторогоПлатежа,
	|	Патенты.Наименование,
	|	Патенты.ДатаНачала,
	|	Патенты.ДатаОкончания
	|ПОМЕСТИТЬ Патенты
	|ИЗ
	|	Справочник.Патенты КАК Патенты
	|ГДЕ
	|	Патенты.Владелец = &Организация
	|	И НЕ Патенты.ПометкаУдаления
	|	И Патенты.СуммаПервогоПлатежа > 0
	|	И Патенты.ДатаПервогоПлатежа > Патенты.ДатаНачала
	|	И Патенты.ДатаНачала >= НАЧАЛОПЕРИОДА(&ТекущаяДата, ГОД)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Патенты.Ссылка КАК Правило,
	|	Патенты.ДатаПервогоПлатежа КАК Срок,
	|	Патенты.ДатаНачала КАК НачалоВыполнения,
	|	НАЧАЛОПЕРИОДА(Патенты.ДатаНачала, ГОД) КАК ПериодСобытия,
	|	0 КАК ПорядокПлатежа,
	|	Патенты.Наименование КАК Наименование
	|ИЗ
	|	Патенты КАК Патенты
	|ГДЕ
	|	Патенты.ДатаПервогоПлатежа = Патенты.ДатаОкончания
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Патенты.Ссылка,
	|	Патенты.ДатаПервогоПлатежа,
	|	Патенты.ДатаНачала,
	|	НАЧАЛОПЕРИОДА(Патенты.ДатаНачала, ГОД),
	|	1,
	|	Патенты.Наименование
	|ИЗ
	|	Патенты КАК Патенты
	|ГДЕ
	|	Патенты.ДатаВторогоПлатежа > Патенты.ДатаНачала
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Патенты.Ссылка,
	|	Патенты.ДатаВторогоПлатежа,
	|	Патенты.ДатаНачала,
	|	КОНЕЦПЕРИОДА(Патенты.ДатаНачала, ГОД),
	|	2,
	|	Патенты.Наименование
	|ИЗ
	|	Патенты КАК Патенты
	|ГДЕ
	|	Патенты.ДатаВторогоПлатежа > Патенты.ДатаНачала";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
			НоваяЗапись = ТаблицаПравил.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
			НоваяЗапись.Наименование = Стршаблон(НСтр("ru = 'Патент "+Выборка.Наименование
				+ ", уплата %1стоимости'"), ПорядокПлатежей[Выборка.ПорядокПлатежа]);
	КонецЦикла;
	
	Возврат ТаблицаПравил;
	
КонецФункции

Функция НовыйТаблицаПравил()
	
	ТаблицаПравил = Новый ТаблицаЗначений;
	ТаблицаПравил.Колонки.Добавить("Правило",          Новый ОписаниеТипов("СправочникСсылка.Патенты"));
	ТаблицаПравил.Колонки.Добавить("Организация",      Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаПравил.Колонки.Добавить("Срок",             Новый ОписаниеТипов("Дата"));
	ТаблицаПравил.Колонки.Добавить("НачалоВыполнения", Новый ОписаниеТипов("Дата"));
	ТаблицаПравил.Колонки.Добавить("ПериодСобытия",    Новый ОписаниеТипов("Дата"));
	ТаблицаПравил.Колонки.Добавить("Наименование",     Новый ОписаниеТипов("Строка"));
	
	Возврат ТаблицаПравил;
	
КонецФункции

Функция ПорядокПлатежей()
	
	ПорядокПлатежей = Новый Массив;
	ПорядокПлатежей.Добавить("");
	ПорядокПлатежей.Добавить("1/3 ");
	ПорядокПлатежей.Добавить("2/3 ");
	
	Возврат ПорядокПлатежей;
	
КонецФункции

#КонецОбласти

#Область ОплатаПатентаИзСпискаСправочника

Функция ДанныеПатента(Патент) Экспорт
	
	ОписаниеПлатежа = ОписаниеПлатежа();
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СправочникПатенты.Ссылка КАК Патент,
	|	СправочникПатенты.Наименование КАК Наименование,
	|	СправочникПатенты.Владелец,
	|	СправочникПатенты.ДатаНачала,
	|	СправочникПатенты.ДатаОкончания,
	|	СправочникПатенты.СуммаПервогоПлатежа,
	|	СправочникПатенты.ДатаПервогоПлатежа,
	|	СправочникПатенты.СуммаВторогоПлатежа,
	|	СправочникПатенты.ДатаВторогоПлатежа,
	|	СправочникПатенты.СуммаПервогоПлатежа + СправочникПатенты.СуммаВторогоПлатежа КАК СуммаПлатежаПолного
	|ПОМЕСТИТЬ ДанныеПатента
	|ИЗ
	|	Справочник.Патенты КАК СправочникПатенты
	|ГДЕ
	|	СправочникПатенты.Ссылка = &Патент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПатента.Патент,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЗадачиБухгалтераНалоговыеПлатежи.ПериодСобытия = НАЧАЛОПЕРИОДА(ДанныеПатента.ДатаНачала, ГОД)
	|					И НЕ ЗадачиБухгалтераНалоговыеПлатежи.ПлатежноеПоручение ЕСТЬ NULL 
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ПервыйПлатежВыполнен,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЗадачиБухгалтераНалоговыеПлатежи.ПериодСобытия = НАЧАЛОПЕРИОДА(КОНЕЦПЕРИОДА(ДанныеПатента.ДатаНачала, ГОД), ДЕНЬ)
	|					И НЕ ЗадачиБухгалтераНалоговыеПлатежи.ПлатежноеПоручение ЕСТЬ NULL 
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ВторойПлатежВыполнен
	|ПОМЕСТИТЬ ТаблицаОплаты
	|ИЗ
	|	ДанныеПатента КАК ДанныеПатента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗадачиБухгалтераНалоговыеПлатежи КАК ЗадачиБухгалтераНалоговыеПлатежи
	|		ПО (ЗадачиБухгалтераНалоговыеПлатежи.Правило = ДанныеПатента.Патент)
	|ГДЕ
	|	ЗадачиБухгалтераНалоговыеПлатежи.ПлатежноеПоручение.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПатента.Патент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПатента.Патент,
	|	ДанныеПатента.Владелец,
	|	ДанныеПатента.Наименование,
	|	ДанныеПатента.ДатаНачала,
	|	ДанныеПатента.ДатаОкончания,
	|	ДанныеПатента.СуммаПервогоПлатежа,
	|	ДанныеПатента.ДатаПервогоПлатежа,
	|	ДанныеПатента.СуммаВторогоПлатежа,
	|	ДанныеПатента.ДатаВторогоПлатежа,
	|	ДанныеПатента.СуммаПлатежаПолного,
	|	ЕСТЬNULL(ТаблицаОплаты.ПервыйПлатежВыполнен, ЛОЖЬ) КАК ПервыйПлатежВыполнен,
	|	ЕСТЬNULL(ТаблицаОплаты.ВторойПлатежВыполнен, ЛОЖЬ) КАК ВторойПлатежВыполнен
	|ИЗ
	|	ДанныеПатента КАК ДанныеПатента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОплаты КАК ТаблицаОплаты
	|		ПО (ТаблицаОплаты.Патент = ДанныеПатента.Патент)";
	Запрос.УстановитьПараметр("Патент", Патент);
	Результат = Запрос.Выполнить().Выбрать();
	Результат.Следующий();
	
	ЗаполнитьЗначенияСвойств(ОписаниеПлатежа, Результат);
	
	ОписаниеПлатежа.Вставить("НомерПлатежа", 1);

	Если ЗначениеЗаполнено(Результат.ДатаВторогоПлатежа) Тогда
		Если НЕ Результат.ПервыйПлатежВыполнен Тогда
			
			СписокПлатежей = Новый СписокЗначений;
			СписокПлатежей.Добавить(1, Формат(Результат.СуммаПервогоПлатежа, "ЧДЦ=0") + " руб., не позднее " + Формат(Результат.ДатаПервогоПлатежа, "ДЛФ=D"));
			СписокПлатежей.Добавить(2, Формат(Результат.СуммаВторогоПлатежа, "ЧДЦ=0") + " руб., не позднее " + Формат(Результат.ДатаВторогоПлатежа, "ДЛФ=D"));
			
			ОписаниеПлатежа.Вставить("СписокПлатежей", СписокПлатежей);
			
		КонецЕсли;
		
		Если Результат.ПервыйПлатежВыполнен ИЛИ Результат.ДатаПервогоПлатежа < ТекущаяДатаСеанса() Тогда
			ОписаниеПлатежа.Вставить("НомерПлатежа", 2);
		КонецЕсли;
		
	КонецЕсли;
	
	ОписаниеПлатежа.Вставить("ОплаченПолностью", Ложь);
	Если ЗначениеЗаполнено(Результат.ДатаВторогоПлатежа)Тогда
		Если Результат.ПервыйПлатежВыполнен И Результат.ВторойПлатежВыполнен Тогда
			ОписаниеПлатежа.Вставить("ОплаченПолностью", Истина);
		КонецЕсли;
	ИначеЕсли Результат.ПервыйПлатежВыполнен Тогда
		ОписаниеПлатежа.Вставить("ОплаченПолностью", Истина);
	КонецЕсли;
	
	Возврат ОписаниеПлатежа;
	
КонецФункции

Функция ОписаниеОплатыПатента(ДанныеПатента) Экспорт
	
	ДатаОплаты = ?(ДанныеПатента.НомерПлатежа = 2, ДанныеПатента.ДатаВторогоПлатежа, ДанныеПатента.ДатаПервогоПлатежа);
	ПериодОплаты = ?(ДанныеПатента.НомерПлатежа = 2, КонецГода(ДанныеПатента.ДатаНачала), НачалоГода(ДанныеПатента.ДатаНачала));
	Возврат ВыполнениеЗадачБухгалтера.ОписаниеДействияУплатаПатента(ДанныеПатента.Владелец, ДанныеПатента.СпособОплаты, ДатаОплаты, ДанныеПатента.Патент, ПериодОплаты);
	
КонецФункции

Функция ОписаниеПлатежа()
	
	ПустоеОписаниеПатента = Новый Структура();
	ПустоеОписаниеПатента.Вставить("Патент");
	ПустоеОписаниеПатента.Вставить("Владелец");
	ПустоеОписаниеПатента.Вставить("Наименование");
	ПустоеОписаниеПатента.Вставить("ДатаНачала");
	ПустоеОписаниеПатента.Вставить("ДатаОкончания");
	ПустоеОписаниеПатента.Вставить("ДатаПервогоПлатежа");
	ПустоеОписаниеПатента.Вставить("ДатаВторогоПлатежа");
	ПустоеОписаниеПатента.Вставить("СписокПлатежей");
	ПустоеОписаниеПатента.Вставить("ОплаченПолностью");
	ПустоеОписаниеПатента.Вставить("СуммаПлатежаПолного");
	ПустоеОписаниеПатента.Вставить("СпособОплаты");
	ПустоеОписаниеПатента.Вставить("НомерПлатежа");
	
	Возврат ПустоеОписаниеПатента;
	
КонецФункции

#КонецОбласти


#Область ПроцедурыОбновленияИБ

// Обработчик обновления 3.0.42.37
Процедура ЗаполнитьДобавленныеРеквизиты() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат ;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Патенты.Ссылка,
	|	Патенты.Наименование,
	|	Патенты.Наименование ПОДОБНО &ШаблонНомераПатента КАК НаименованиеСодержитНомер
	|ИЗ
	|	Справочник.Патенты КАК Патенты
	|ГДЕ
	|	Патенты.ПостановкаНаУчетВНалоговомОргане = &ПустаяПостановка";
	Запрос.УстановитьПараметр("ПустаяПостановка", Перечисления.ПостановкаНаУчетВНалоговомОргане.ПустаяСсылка());
	Запрос.УстановитьПараметр("ШаблонНомераПатента","%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Патент = Выборка.Ссылка.ПолучитьОбъект();
		Патент.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ПоМестуНахожденияОрганизации;
		
		Если Выборка.НаименованиеСодержитНомер Тогда
			НомерПатента = "";
			Наименование = Выборка.Наименование;
			МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Наименование, " ");
			
			Для каждого Подстрока из МассивПодстрок Цикл
				Подстрока = СтрЗаменить(Подстрока,"№","");
				Если СтрДлина(Подстрока) = 13 И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстрока) Тогда
					НомерПатента = Подстрока;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Патент.НомерПатента = НомерПатента;
			
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Патент, Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
