﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтоОбособленноеПодразделение = Ложь;
	ЭтоФизическоеЛицо            = Ложь;
	ОрганизацияСОбособленнымиПодразделениями = Ложь;
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда 
		
		Элементы.Владелец.ТолькоПросмотр = Истина;
		Элементы.Владелец.КнопкаОткрытия = Ложь;
		Элементы.Владелец.КнопкаВыбора = Ложь;
		Элементы.Владелец.АвтоОтметкаНезаполненного = Ложь;
		Элементы.Владелец.ЦветРамки = ЦветаСтиля.ЦветФонаФормы;
		Элементы.Владелец.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
		Элементы.Владелец.ЦветТекста = Новый Цвет(122, 87, 0);
		
		Если Объект.Владелец.Метаданные().Реквизиты.Найти("ЮридическоеФизическоеЛицо") <> Неопределено
			И Объект.Владелец.Метаданные().Реквизиты.Найти("ОбособленноеПодразделение")	<> Неопределено Тогда 
	
			РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец, "ЮридическоеФизическоеЛицо, ОбособленноеПодразделение");
			
			ЭтоОбособленноеПодразделение = РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо
				И РеквизитыОрганизации.ОбособленноеПодразделение;
			
		КонецЕсли;
		
		ЭтоФизическоеЛицо = РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		
		ОрганизацияСОбособленнымиПодразделениями = ЕстьОбособленныеПодразделения(Объект.Владелец);
		
	КонецЕсли;
	
	Элементы.КПП.Видимость = НЕ ЭтоФизическоеЛицо;
	
	Если ЭтоОбособленноеПодразделение Тогда
		
		ГоловнаяОрганизация = РегламентированнаяОтчетность.ГоловнаяОрганизация(Объект.Владелец);
				
	Иначе
		
		Элементы.Владелец.Заголовок	= НСтр("ru = 'Организация'");
		Элементы.ГоловнаяОрганизация.Видимость = Ложь;
		Элементы.НаименованиеОбособленногоПодразделения.Видимость = ОрганизацияСОбособленнымиПодразделениями;
		Элементы.ПодсказкаНаименованиеОбособленногоПодразделения.Видимость = ОрганизацияСОбособленнымиПодразделениями;
	
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
				
		Элементы.Владелец.Видимость = Ложь;
		
	КонецЕсли;
	
	ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(Объект.Представитель), 1, 0);
	
	УстановитьПредставлениеПлатежныхРеквизитов(Перечисления.ВидыГосударственныхОрганов.НалоговыйОрган, Объект.Код, ПлатежныеРеквизитыФНСПредставление);
	
	Если ЭтоФизическоеЛицо Тогда
		
		Элементы.ОтчетностьПодписываетПредставитель.СписокВыбора[0].Представление = НСтр("ru='Индивидуальный предприниматель'");
		
	Конецесли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Модифицированность = Истина;
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		Если ВыбранноеЗначение.Свойство("Представитель") Тогда
			ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(Объект.Представитель), 1, 0);
		КонецЕсли;
	
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОтчетностьПодписываетПредставитель = 1
		И НЕ ЗначениеЗаполнено(Объект.Представитель) Тогда
		
		ТекстСообщения = НСтр("ru = 'Заполните сведения о представителе'"); 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПредставлениеПредставителя",, Отказ);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	СуществующаяЗапись = РегистрацияВИФНС();
	
	Если СуществующаяЗапись <> Неопределено И СуществующаяЗапись <> Объект.Ссылка Тогда
			
		ПоказатьПредупреждение(, НСтр("ru = 'Для данной организации уже существует запись с указанными кодом налогового органа'") 
						         + ?(СтрДлина(Объект.КПП) < 9, ".", НСтр("ru = ' и КПП.'")));
		
		Отказ = Истина;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("НовыйЭлемент", ТекущийОбъект.Ссылка.Пустая());
	
	Если ОтчетностьПодписываетПредставитель = 0 Тогда
		ТекущийОбъект.Представитель						= Неопределено;
		ТекущийОбъект.УполномоченноеЛицоПредставителя	= "";
		ТекущийОбъект.ДокументПредставителя				= "";
		ТекущийОбъект.Доверенность						= "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура("Ссылка, Владелец", Объект.Ссылка, Объект.Владелец);
	
	Оповестить("ИзмененаРегистрацияВНалоговомОргане", ПараметрОповещения);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КПППриИзменении(Элемент)

	Объект.Код	= Лев(СокрЛ(Объект.КПП), 4);

КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
		
	Если ЭтоФизическоеЛицо() Тогда
		
		Элементы.ОтчетностьПодписываетПредставитель.СписокВыбора[0].Представление = НСтр("ru='Индивидуальный предприниматель'");
		
	Иначе
		
		Элементы.ОтчетностьПодписываетПредставитель.СписокВыбора[0].Представление = НСтр("ru='Руководитель'");
		
	Конецесли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)

	Если ПустаяСтрока(Объект.НаименованиеИФНС) Тогда
		
		НаименованиеИФНС = Объект.Наименование;
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='МИФНС'"),	НСтр("ru='Межрайонная инспекция федеральной налоговой службы'"));
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='ИФНС'"),	НСтр("ru='Инспекция федеральной налоговой службы'"));
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='ФНС'"),	НСтр("ru='Федеральная налоговая служба'"));
		
		Объект.НаименованиеИФНС	= НаименованиеИФНС;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетностьПодписываетПредставительПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПредставителяНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначенияЗаполнения = Новый Структура("Владелец,Представитель,УполномоченноеЛицоПредставителя,ДокументПредставителя,Доверенность");
	ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, Объект);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.Форма.ФормаПредставителя", ПараметрыФормы, ЭтаФорма, КлючУникальности);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПоОКАТОПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КодПоОКАТО) Тогда
		
		ДлинаЗначения = СтрДлина(СокрЛП(Объект.КодПоОКАТО));
		
		Для Инд = ДлинаЗначения + 1 По 11 Цикл
			
			Объект.КодПоОКАТО = СокрЛП(Объект.КодПоОКАТО) + "0";
			
		КонецЦикла;
		
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыНалоговогоОрганаПоКоду(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Код) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""Код"" не заполнено'"));
		ТекущийЭлемент = Элементы.Код;
		Возврат;
	КонецЕсли;
	
	ВыполнитьЗаполнениеСведенийОНалоговойИнспекции();
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежныеРеквизитыФНСПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидГосударственногоОргана", ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.НалоговыйОрган"));
	ПараметрыФормы.Вставить("КодГосударственногоОргана", Объект.Код);
	ПараметрыФормы.Вставить("НаименованиеГосударственногоОргана", Объект.НаименованиеИФНС);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзменениеПлатежныхРеквизитовФНС", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ПлатежныеРеквизитыГосударственныхОрганов", ПараметрыФормы, ЭтаФорма, ЭтаФорма, , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	ЗаполнитьСведенияОНалоговойИнспекцииПоКоду();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Форма.ОтчетностьПодписываетПредставитель = 1 Тогда
		Форма.Элементы.ГруппаПредставлениеПредставителяСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПредставительГиперссылка;
	Иначе
		Форма.Элементы.ГруппаПредставлениеПредставителяСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПредставительНеВыбран;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Представитель) Тогда
		Форма.ПредставлениеПредставителя = НСтр("ru = 'Заполнить'");
	ИначеЕсли ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.ФизическиеЛица")
		ИЛИ НЕ ЗначениеЗаполнено(Объект.УполномоченноеЛицоПредставителя) Тогда
		Форма.ПредставлениеПредставителя = Объект.Представитель;
	ИначеЕсли ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.Контрагенты") Тогда
		Форма.ПредставлениеПредставителя = Объект.УполномоченноеЛицоПредставителя + " (" + Объект.Представитель + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьОбособленныеПодразделения(Знач Организация)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПодразделенияОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	ПодразделенияОрганизаций.Владелец = &Организация
	|	И ПодразделенияОрганизаций.ОбособленноеПодразделение
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ГоловнаяОрганизация = &Организация
	|	И Организации.ОбособленноеПодразделение";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Функция РегистрацияВИФНС()
	
	Возврат РегламентированнаяОтчетность.ПолучитьПоКодамРегистрациюВИФНС(Объект.Владелец, Объект.Код, Объект.КПП);	
	
КонецФункции

&НаКлиенте
Функция ВыполнитьЗаполнениеСведенийОНалоговойИнспекции()
	
	ОписаниеОшибки = "";
	ЗаполнитьСведенияОНалоговойИнспекцииПоКоду(ОписаниеОшибки);
	
	// Обработка ошибок
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			
			ТекстВопроса = НСтр("ru='Для автоматического заполнения реквизитов контрагентов
				|необходимо подключиться к Интернет-поддержке пользователей.
				|Подключиться сейчас?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		ИначеЕсли ОписаниеОшибки = "Сервис1СКонтрагентНеПодключен" Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИдентификаторМестаВызова", "registraciya_v_no");
			ОткрытьФорму("ОбщаяФорма.Сервис1СКонтрагентНеПодключен", ПараметрыФормы, ЭтотОбъект);
			
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСведенияОНалоговойИнспекцииПоКоду(ОписаниеОшибки = "")
	
	Если НЕ ЗначениеЗаполнено(Объект.Код) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыНалоговогоОргана = ДанныеГосударственныхОрганов.РеквизитыНалоговогоОрганаПоКоду(Объект.Код);
	
	Если ЗначениеЗаполнено(РеквизитыНалоговогоОргана.ОписаниеОшибки) Тогда
		ОписаниеОшибки = РеквизитыНалоговогоОргана.ОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РеквизитыНалоговогоОргана.Ссылка) Тогда
		ДанныеГосударственныхОрганов.ОбновитьДанныеГосударственногоОргана(РеквизитыНалоговогоОргана);
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ПлатежныеРеквизитыФНСПредставление = ДанныеГосударственныхОрганов.ПредставлениеПлатежныхРеквизитовГосударственногоОргана(РеквизитыНалоговогоОргана);
	
	Объект.Наименование     = РеквизитыНалоговогоОргана.Наименование;
	Объект.НаименованиеИФНС = РеквизитыНалоговогоОргана.ПолноеНаименование;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеПлатежныхРеквизитов(Вид, Код, ПлатежныеРеквизитыПредставление)
	
	Если ЗначениеЗаполнено(Код) Тогда
		ГосударственныйОрган = ДанныеГосударственныхОрганов.ГосударственныйОрган(Вид, Код);
	Иначе
		ГосударственныйОрган = Неопределено;
	КонецЕсли;
	
	ПлатежныеРеквизитыПредставление = ДанныеГосударственныхОрганов.ПредставлениеПлатежныхРеквизитовГосударственногоОргана(ГосударственныйОрган);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеПлатежныхРеквизитовФНС(Ответ, ДопПараметры) Экспорт
	
	Если ТипЗнч(Ответ) = Тип("Структура") Тогда
		
		ПлатежныеРеквизитыФНСПредставление = Ответ.ПлатежныеРеквизиты.ПолучательПлатежа;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДопПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержку();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЭтоФизическоеЛицо()
	
	Если Объект.Владелец.Метаданные().Реквизиты.Найти("ЮридическоеФизическоеЛицо") <> Неопределено
		И Объект.Владелец.Метаданные().Реквизиты.Найти("ОбособленноеПодразделение") <> Неопределено Тогда 
		
		РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец, "ЮридическоеФизическоеЛицо, ОбособленноеПодразделение");
		
		Возврат РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти