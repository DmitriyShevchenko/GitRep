﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка= Ложь;
		Возврат;
	КонецЕсли;

	ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Ложь;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() Тогда
			Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
			ПолучитьТекущегоПользователя = Ложь;
			ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Истина;
		Иначе
			ПолучитьТекущегоПользователя = Истина;
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
	КонецЕсли;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ЭтаФорма.ПараметрыСеанса_ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	Иначе
		ЭтаФорма.ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	лкТекущаяУниверсальнаяДата = ТекущаяУниверсальнаяДата();

	// Новости не должны создаваться - только читаться, поэтому если Ключ не заполнен, то форму не открывать.
	Если Параметры.Ключ.Пустая() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='В справочнике новостей нельзя создавать новости вручную.
			|Используйте загрузку новостей из лент новостей.'");
		Сообщение.Сообщить();
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если ВРег(Параметры.РежимОткрытияОкна) = ВРег("БлокироватьОкноВладельца") Тогда
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе // Все остальные значения
		// По-умолчанию - независимое открытие.
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (
				РольДоступна(Метаданные.Роли.АдминистраторСистемы)
				ИЛИ РольДоступна(Метаданные.Роли.ПолныеПрава)
				ИЛИ РольДоступна(Метаданные.Роли.ЧтениеНовостей)) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

	// Заполнение реквизитов для новости, требующей прочтения.
	// Если новость важная или очень важная, то признак прочтенности имеет особое значение и означает,
	// что новость больше не должна назойливо всплывать.
	// Поэтому для простой новости прочтенность можно устанавливать уже на этапе создания окна, а для
	//  важных и очень важных новостей - только пользователем.

	// Определить, установлена ли важность для контекстного представления новости?
	ЭтаФорма.УстановленаВажностьДляКонтекстнойНовости = Ложь;
	Если (Объект.ДатаЗавершения = '00010101')
			ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда
		Для каждого ТекущаяПривязкаКМетаданным Из Объект.ПривязкаКМетаданным Цикл
			// Важность для контекстной новости установлена?
			Если (ТекущаяПривязкаКМетаданным.Важность = 1)
					ИЛИ (ТекущаяПривязкаКМетаданным.Важность = 2) Тогда
				// Дата сброса важности установлена? Сброс важности наступил?
				Если (ТекущаяПривязкаКМетаданным.ДатаСбросаВажности = '00010101')
						ИЛИ (ТекущаяПривязкаКМетаданным.ДатаСбросаВажности > лкТекущаяУниверсальнаяДата) Тогда
					ЭтаФорма.УстановленаВажностьДляКонтекстнойНовости = Истина;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Если ДатаСбросаВажности пустая или >= ТекущаяУниверсальнаяДата(), то важность имеет значение, иначе Важность = 0.
	ЭтаФорма.ВажностьНаТекущуюДату = 0;
	Если (Объект.ДатаЗавершения = '00010101')
			ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда // Новость еще актуальна?
		Если (Объект.ДатаСбросаВажности = '00010101')
				ИЛИ (Объект.ДатаСбросаВажности > лкТекущаяУниверсальнаяДата) Тогда
			ЭтаФорма.ВажностьНаТекущуюДату = Объект.Важность;
		КонецЕсли;
	КонецЕсли;

	ЭтаФорма.ТребуетПрочтения = Ложь;
	Если (Объект.ДатаЗавершения = '00010101')
			ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда // Новость еще актуальна?
		Если (ЭтаФорма.ВажностьНаТекущуюДату = 1)
				ИЛИ (ЭтаФорма.ВажностьНаТекущуюДату = 2)
				ИЛИ (ЭтаФорма.УстановленаВажностьДляКонтекстнойНовости = Истина) Тогда
			ЭтаФорма.ТребуетПрочтения = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Истина Тогда
		ЭтаФорма.ПрочтенаПриОткрытии           = Истина;
		ЭтаФорма.ДатаНачалаОповещения          = '00010101';
		ЭтаФорма.ОповещениеВключено            = Ложь;
		ЭтаФорма.Пометка                       = 0;
		ЭтаФорма.ОповещениеВключеноПриОткрытии = Ложь;
	Иначе
		// Загрузить из базы состояние новости:
		//  - Прочтена;
		//  - Пометка;
		//  - ОповещениеВключено (имеет смысл только для важных и очень важных новостей);
		//  - ДатаНачалаОповещения (имеет смысл только для важных и очень важных новостей) // Пока не появится кнопка Отложить, всегда = пустой дате.
		Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
		Запись.Пользователь = ЭтаФорма.ПараметрыСеанса_ТекущийПользователь;
		Запись.Новость      = Объект.Ссылка;
		Запись.Прочитать();
		Если Запись.Выбран() Тогда
			ЭтаФорма.ПрочтенаПриОткрытии           = Запись.Прочтена; // Для определения (при закрытии формы) - надо ли делать запись в регистр сведений.
			ЭтаФорма.ДатаНачалаОповещения          = Запись.ДатаНачалаОповещения;
			ЭтаФорма.ОповещениеВключено            = Запись.ОповещениеВключено;
			ЭтаФорма.Пометка                       = Запись.Пометка;
			ЭтаФорма.ОповещениеВключеноПриОткрытии = ЭтаФорма.ОповещениеВключено;
		Иначе
			ЭтаФорма.ПрочтенаПриОткрытии   = Ложь; // Для определения при закрытии - надо ли делать запись в регистр сведений.
			ЭтаФорма.ОповещениеВключеноПриОткрытии = Ложь;
			Если ЭтаФорма.ТребуетПрочтения = Истина Тогда
				Если Объект.АвтоСбросНапоминанияПриПрочтении = Истина Тогда
					ЭтаФорма.ОповещениеВключено = Ложь;
				Иначе
					ЭтаФорма.ОповещениеВключено = Истина;
				КонецЕсли;
			Иначе
				ЭтаФорма.ОповещениеВключено = Ложь;
			КонецЕсли;
			ЭтаФорма.ДатаНачалаОповещения = '00010101';
			ЭтаФорма.Пометка = 0;
		КонецЕсли;
		ЭтаФорма.Прочтена = Истина; // При открытии признак Прочтена = Истина всегда, вне зависимости от сохраненного состояния новости.
		ЭтаФорма.ПометкаПриОткрытии = ЭтаФорма.Пометка;
	КонецЕсли;

	// Если новость уже неактуальна, но была установлена важность, то сбросить признак оповещения.
	Если (Объект.ДатаЗавершения <> '00010101')
			И (Объект.ДатаЗавершения <= лкТекущаяУниверсальнаяДата)
			И (ЭтаФорма.ОповещениеВключено = Истина) Тогда // Новость уже неактуальна, но было включено оповещение.
		ЭтаФорма.ОповещениеВключено = Ложь;
		ЭтаФорма.СостояниеНовостиИзменено = Истина; // Принудительно установить признак, чтобы при закрытии записалось новое состояние.
	КонецЕсли;

	// Если флажок ПриОткрытииСразуПереходитьПоСсылке = Истина и задана ссылка на полный текст новости
	//  в реквизите СсылкаНаПолныйТекстНовости, то не открывать форму, а сразу перейти по ссылке.
	// Причем, ссылка может вести как на внешний сайт, так и на объекты метаданных,
	//  разделы справки и т.п. (если начинается на "1C:" английскими буквами).
	// Подробности см. в ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки.
	Если Объект.ПриОткрытииСразуПереходитьПоСсылке = Истина Тогда
		Если НЕ ПустаяСтрока(Объект.СсылкаНаПолныйТекстНовости) Тогда
			// Отметить такую новость как прочтенную и сбросить признак оповещения сразу,
			//  т.к. формы для просмотра у этой новости (где можно нажать кнопку "Прочтено" / "Оповещение") нет.
			// Записывать настройки нельзя при работе разделенной конфигурации в неразделенном сеансе.
			Если ПропуститьЧтениеЗаписьПользовательскихНастроекНовости <> Истина Тогда
				ЗаписатьИзменениеСостоянияНовостиСервер(
					Объект.Ссылка,
					Истина, // ЭтаФорма.Прочтена,
					ЭтаФорма.Пометка,
					Ложь, // ЭтаФорма.ОповещениеВключено,
					'00010101', // ЭтаФорма.ДатаНачалаОповещения
					ЭтаФорма.ПараметрыСеанса_ТекущийПользователь
				);
			КонецЕсли;
			// Прервать открытие формы.
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если ЭтаФорма.ТребуетПрочтения = Истина Тогда
		Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьТребуетПрочтения;
	Иначе
		Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьНеТребуетПрочтения;
	КонецЕсли;

	// Текст новости.
	ЭтаФорма.ТекстНовости = ОбработкаНовостейПовтИсп.ПолучитьХТМЛТекстНовостей(Объект.Ссылка);

	ЭтаФорма.Заголовок = Объект.Наименование;

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуНовостиПриСозданииНаСервере(
		ЭтаФорма,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// Если ПриОткрытииСразуПереходитьПоСсылке = Истина и задана ссылка
	//  на полный текст новости в реквизите СсылкаНаПолныйТекстНовости, то не открывать форму, а сразу перейти по ссылке.
	// Причем, ссылка может вести как на внешний сайт, так и на объекты метаданных,
	//  разделы справки и т.п. (если начинается на "1C:" английскими буквами).
	// Подробности см. в ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки.
	НавигационнаяСсылка = Объект.СсылкаНаПолныйТекстНовости;
	Если Объект.ПриОткрытииСразуПереходитьПоСсылке = Истина Тогда
		Если НЕ ПустаяСтрока(НавигационнаяСсылка) Тогда

			// Некоторые браузеры (например, FF33) добавляют полный адрес к параметру href и тогда вместо "1C:Act001" получается "http://ПутьКБазе/1C:Act001".
			Если Найти(ВРег(НавигационнаяСсылка), ВРег("http")) = 1 Тогда
				ГдеРазделитель1С = Найти(ВРег(НавигационнаяСсылка), ВРег("/1C:"));
				Если ГдеРазделитель1С > 0 Тогда // 1C - "С" - английская
					НавигационнаяСсылка = Прав(НавигационнаяСсылка, СтрДлина(НавигационнаяСсылка) - ГдеРазделитель1С);
				КонецЕсли;
			КонецЕсли;

			Если Найти(ВРег(НавигационнаяСсылка), ВРег("http")) = 1 Тогда
				ОбработкаНовостейКлиент.ПерейтиПоИнтернетСсылке(НавигационнаяСсылка);
				Отказ = Истина;
				Возврат;
			ИначеЕсли Найти(ВРег(НавигационнаяСсылка), ВРег("e1c://")) = 1 Тогда
				ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка);
				Отказ = Истина;
				Возврат;
			ИначеЕсли Найти(ВРег(НавигационнаяСсылка), ВРег("e1cib/")) = 1 Тогда
				ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка);
				Отказ = Истина;
				Возврат;
			ИначеЕсли Найти(ВРег(НавигационнаяСсылка), ВРег("1C:")) = 1 Тогда // 1C - "С" - английская
				// Запустить ОбработкаНавигационнойСсылки с параметрами.
				Действие = "";
				СписокПараметров = Неопределено;
				ОбработкаНовостейВызовСервера.ПодготовитьПараметрыНавигационнойСсылки(Объект.Ссылка, НавигационнаяСсылка, Действие, СписокПараметров);
				ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки(Объект.Ссылка, Неопределено, Действие, СписокПараметров);
				Отказ = Истина;
				Возврат;
			Иначе
				ТекстСообщения = НСтр("ru='Неизвестная ссылка: %НавигационнаяСсылка%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НавигационнаяСсылка%", НавигационнаяСсылка);
				ПоказатьПредупреждение(
					, // ОписаниеОповещенияОЗавершении
					ТекстСообщения,
					0,
					НСтр("ru='Ошибка'")); 
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ЭтаФорма.ПодключитьОбработчикОжидания("Подключаемый_АктивизироватьФорму", 0.2, Истина);

	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	// Если включено разделение данных, и мы зашли в неразделенном сеансе,
	//  то нельзя устанавливать пользовательские свойства новости.
	// Определить, как мы зашли, можно по отключенной командной панели.
	Если Элементы.ГруппаКоманднаяПанель.Видимость = Ложь Тогда
		Возврат;
	КонецЕсли;

	Если ЭтаФорма.Прочтена <> ЭтаФорма.ПрочтенаПриОткрытии Тогда
		ЭтаФорма.СостояниеНовостиИзменено = Истина;
		Оповестить(
			"Новости. Новость прочтена",
			ЭтаФорма.Прочтена,
			Объект.Ссылка);
	КонецЕсли;

	Если ЭтаФорма.ТребуетПрочтения = Истина Тогда
		Если ЭтаФорма.ОповещениеВключено <> ЭтаФорма.ОповещениеВключеноПриОткрытии Тогда
			ЭтаФорма.СостояниеНовостиИзменено = Истина;
			Оповестить(
				"Новости. Изменено состояние оповещения о новости",
				ЭтаФорма.ОповещениеВключено,
				Объект.Ссылка);
			// Для новостей с изменившимся признаком Оповещение очистить кэш контекстных новостей.
			// Причем не имеет значения - включили признак, или выключили.
			Для Каждого ПараметрыКонтекстнойНовости Из Объект.ПривязкаКМетаданным Цикл
				ОбработкаНовостейКлиент.УдалитьКонтекстныеНовостиИзКэшаПриложения(
					ПараметрыКонтекстнойНовости.Метаданные,
					ПараметрыКонтекстнойНовости.Форма);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Если ЭтаФорма.Пометка <> ЭтаФорма.ПометкаПриОткрытии Тогда
		ЭтаФорма.СостояниеНовостиИзменено = Истина;
		МассивНовостей = Новый Массив;
		МассивНовостей.Добавить(Объект.Ссылка);
		Оповестить(
			"Новости. Изменена пометка списка новостей",
			ЭтаФорма.Пометка,
			МассивНовостей);
	КонецЕсли;

	Если ЭтаФорма.СостояниеНовостиИзменено = Истина Тогда
		Если НЕ ЭтаФорма.ПараметрыСеанса_ТекущийПользователь.Пустая() Тогда
			ЗаписатьИзменениеСостоянияНовостиСервер(
				Объект.Ссылка,
				ЭтаФорма.Прочтена,
				ЭтаФорма.Пометка,
				ЭтаФорма.ОповещениеВключено,
				ЭтаФорма.ДатаНачалаОповещения,
				ЭтаФорма.ПараметрыСеанса_ТекущийПользователь);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстНовостиПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	лкОбъект = Объект; // При открытии из формы элемента справочника / документа

	ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(лкОбъект, ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ПометкаНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Если ЭтаФорма.Пометка > 0 Тогда
		ЭтаФорма.Пометка = 0;
	Иначе
		ЭтаФорма.Пометка = 1;
	КонецЕсли;
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВключеноПриИзменении(Элемент)

	УправлениеФормой();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицыФормы
#КонецОбласти

#Область ОбработчикиКомандФормы
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Управление видимостью и доступностью элементов формы.
//
&НаКлиенте
Процедура УправлениеФормой()

	Если ЭтаФорма.Пометка = 0 Тогда
		Элементы.Пометка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Выпуклая);
		Элементы.Пометка.Подсказка = "Новость не отмечена";
	Иначе
		Элементы.Пометка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Вдавленная);
		Элементы.Пометка.Подсказка = "Новость отмечена";
	КонецЕсли;

	Если ЭтаФорма.ОповещениеВключено Тогда
		Элементы.СтраницыКартинкиОповещения.ТекущаяСтраница = Элементы.СтраницаОповещениеВключено;
	Иначе
		Элементы.СтраницыКартинкиОповещения.ТекущаяСтраница = Элементы.СтраницаОповещениеОтключено;
	КонецЕсли;

КонецПроцедуры

// Активизирует окно формы, на случай если оно перекрылось другими формами.
//
&НаКлиенте
Процедура Подключаемый_АктивизироватьФорму()

	ЭтаФорма.Активизировать();

КонецПроцедуры

&НаСервереБезКонтекста
// Процедура записывает регистр сведений "СостоянияНовостей".
//
// Параметры:
//  НовостьСсылка          - СправочникСсылка.Новости;
//  лкПрочтена             - Булево;
//  лкПометка              - Число (1,0);
//  лкОповещениеВключено   - Булево;
//  лкДатаНачалаОповещения - Дата;
//  лкТекущийПользователь  - СправочникСсылка.Пользователи.
//
Процедура ЗаписатьИзменениеСостоянияНовостиСервер(
			НовостьСсылка,
			лкПрочтена,
			лкПометка,
			лкОповещениеВключено,
			лкДатаНачалаОповещения,
			лкТекущийПользователь)

	Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
	Запись.Пользователь = лкТекущийПользователь;
	Запись.Новость      = НовостьСсылка;
	Запись.Прочитать(); // На тот случай, если были установлены другие свойства.
	// Вдруг новость не выбрана (т.е. ее нет в базе) - перезаполнить менеджер записи и записать.
	Запись.Пользователь         = лкТекущийПользователь;
	Запись.Новость              = НовостьСсылка;
	Запись.Прочтена             = лкПрочтена;
	Запись.Пометка              = лкПометка;
	Запись.ОповещениеВключено   = лкОповещениеВключено;
	Запись.ДатаНачалаОповещения = лкДатаНачалаОповещения;
	Запись.Записать(Истина);

КонецПроцедуры

#КонецОбласти

