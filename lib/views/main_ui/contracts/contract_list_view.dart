import 'package:certipay/services/contracts/contract.dart';
import 'package:certipay/utilities/dialogs/cancel_dialog.dart';
import 'package:certipay/utilities/models/contracts_model.dart';
import 'package:certipay/views/main_ui/contracts/detailed_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

typedef ContractCallback = void Function(Contract contract);

class ContractListView extends StatelessWidget {
  ContractListView({
    Key? key,
  }) : super(key: key);

  static Map<String, IconData> iconMap = {
    "Health": Icons.health_and_safety,
    "Habits": Icons.timelapse,
    "Sports": Icons.sports,
    "Generic": Icons.miscellaneous_services
  };

  @override
  Widget build(BuildContext context) {
    var contracts = context.watch<ContractsModel>();

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        thickness: 1,
        indent: 10,
        endIndent: 10,
        color: Colors.black,
      ),
      itemCount: contracts.contractsInUse.length,
      itemBuilder: (context, index) {
        final contract = contracts.contractsInUse.elementAt(index);
        return ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailedContractView(
                contract: contract,
              ),
            ));
          },
          title: Text(
            contract.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          leading: Icon(iconMap[contract.category.name]),
        );
      },
    );
  }
}
