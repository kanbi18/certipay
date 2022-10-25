import 'package:certipay/services/contracts/contract.dart';
import 'package:certipay/utilities/dialogs/cancel_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

typedef ContractCallback = void Function(Contract contract);

class ContractListView extends StatelessWidget {
  final Iterable<Contract> contracts;
  final ContractCallback onCancelContract;
  final ContractCallback onTap;

  const ContractListView({
    Key? key,
    required this.contracts,
    required this.onCancelContract,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contracts.length,
      itemBuilder: (context, index) {
        final contract = contracts.elementAt(index);
        return ListTile(
          onTap: () {},
          title: Text(
            contract.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldCancel = await showCancelDialog(context);
              if (shouldCancel) {
                onCancelContract(contract);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
