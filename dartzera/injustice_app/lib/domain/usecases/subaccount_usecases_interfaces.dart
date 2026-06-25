import '../../core/patterns/i_usecases.dart';
import '../../core/typedefs/types_defs.dart'
    show
        NoParams,
        SubAccountResult,
        ListSubAccountResult,
        SubAccountParams,
        SubAccountIdParams;

abstract interface class ISaveSubAccountUseCase
    implements IUseCase<SubAccountResult, SubAccountParams> {}

abstract interface class IUpdateSubAccountUseCase
    implements IUseCase<SubAccountResult, SubAccountParams> {}

abstract interface class IGetAllSubAccountsUseCase
    implements IUseCase<ListSubAccountResult, NoParams> {}

abstract interface class IGetSubAccountByIdUseCase
    implements IUseCase<SubAccountResult, SubAccountIdParams> {}

abstract interface class IDeleteSubAccountUseCase
    implements IUseCase<SubAccountResult, SubAccountIdParams> {}